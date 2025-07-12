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
    wire [6:0] xor_result = (train_valid) ? (train_pc ^ train_history) : (predict_pc ^ ghr);
    
    // Prediction outputs
    assign predict_taken = pht[xor_result][1];
    assign predict_history = ghr;
    
    // Training logic
    wire do_train = train_valid && ((train_taken && pht[xor_result] != 2'b11) || 
                                  (!train_taken && pht[xor_result] != 2'b00));
    
    wire [PHT_WIDTH-1:0] updated_counter = 
        (train_taken) ? (pht[xor_result] + 1'b1) : (pht[xor_result] - 1'b1);
    
    // GHR update logic
    wire [6:0] next_ghr;
    assign next_ghr = (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
                     (predict_valid) ? {ghr[5:0], predict_taken} :
                     ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT only when needed
            if (do_train) begin
                pht[xor_result] <= updated_counter;
            end
        end
    end

endmodule