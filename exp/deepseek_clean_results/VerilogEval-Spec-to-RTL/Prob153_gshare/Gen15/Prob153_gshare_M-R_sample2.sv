module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Parameters
    localparam PHT_SIZE = 128;
    localparam PHT_WIDTH = 2;

    // Registers
    reg [6:0] ghr;
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Shared XOR for index calculation
    wire [6:0] current_index = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);

    // Prediction output
    assign predict_taken = pht[predict_pc ^ ghr][1];
    assign predict_history = ghr;

    // PHT update signals
    wire pht_update = train_valid && (|current_index || |train_pc); // Ensure valid index
    wire [PHT_WIDTH-1:0] current_pht_value = pht[current_index];
    wire [PHT_WIDTH-1:0] new_pht_value;

    // Efficient saturating counter logic
    assign new_pht_value = train_taken ? 
                          (current_pht_value == 2'b11 ? 2'b11 : current_pht_value + 1) :
                          (current_pht_value == 2'b00 ? 2'b00 : current_pht_value - 1);

    // GHR update logic - simplified priority
    wire ghr_update = train_mispredicted || predict_valid;
    wire [6:0] next_ghr = train_mispredicted ? {train_history[5:0], train_taken} :
                          {ghr[5:0], predict_taken};

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR only when needed
            if (ghr_update) begin
                ghr <= next_ghr;
            end

            // Update PHT only for relevant entry and when it would change
            if (pht_update && (new_pht_value != current_pht_value)) begin
                pht[current_index] <= new_pht_value;
            end
        end
    end

endmodule