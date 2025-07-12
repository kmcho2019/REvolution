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
    
    // Global History Register
    reg [6:0] ghr;
    
    // Pattern History Table
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];
    
    // Shared XOR for index calculation
    wire [6:0] current_index = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);
    
    // Prediction output
    assign predict_taken = pht[predict_pc ^ ghr][1];
    assign predict_history = ghr;
    
    // Next GHR value (optimized to avoid redundant updates)
    wire [6:0] next_ghr;
    assign next_ghr = (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
                     (predict_valid && !(train_valid && train_mispredicted)) ? {ghr[5:0], predict_taken} :
                     ghr;
    
    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset logic
            ghr <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Conditional PHT update (only when needed)
            if (train_valid) begin
                case (pht[current_index])
                    2'b00: pht[current_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[current_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[current_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[current_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end
        end
    end

endmodule