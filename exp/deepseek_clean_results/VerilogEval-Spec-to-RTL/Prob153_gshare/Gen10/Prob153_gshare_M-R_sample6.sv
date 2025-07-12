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

    parameter PHT_SIZE = 128;
    parameter PHT_WIDTH = 2;

    // 7-bit global history register
    reg [6:0] ghr;
    // Pattern history table (2-bit saturating counters)
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Prediction index and output
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Next GHR value calculation
    wire [6:0] next_ghr;
    assign next_ghr = (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
                     (predict_valid) ? {ghr[5:0], predict_taken} :
                     ghr;

    // PHT update logic
    wire [PHT_WIDTH-1:0] next_pht [0:PHT_SIZE-1];
    genvar i;
    generate
        for (i = 0; i < PHT_SIZE; i = i + 1) begin : pht_update
            assign next_pht[i] = (train_valid && (train_index == i)) ?
                               (train_taken ? 
                                   (pht[i] == 2'b11 ? 2'b11 : pht[i] + 1) :
                                   (pht[i] == 2'b00 ? 2'b00 : pht[i] - 1)) :
                               pht[i];
        end
    endgenerate

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer j = 0; j < PHT_SIZE; j = j + 1) begin
                pht[j] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT
            for (integer j = 0; j < PHT_SIZE; j = j + 1) begin
                pht[j] <= next_pht[j];
            end
        end
    end

endmodule