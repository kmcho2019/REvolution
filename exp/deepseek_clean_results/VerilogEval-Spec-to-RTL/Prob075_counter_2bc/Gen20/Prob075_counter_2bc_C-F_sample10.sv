module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding constants
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;  // Async reset to weakly not-taken
    end
    else if (train_valid) begin
        case ({train_taken, state})
            // Increment cases (train_taken = 1)
            {1'b1, S0}: state <= S1;
            {1'b1, S1}: state <= S2;
            {1'b1, S2}: state <= S3;
            {1'b1, S3}: state <= S3;  // Saturate at max
            
            // Decrement cases (train_taken = 0)
            {1'b0, S0}: state <= S0;  // Saturate at min
            {1'b0, S1}: state <= S0;
            {1'b0, S2}: state <= S1;
            {1'b0, S3}: state <= S2;
        endcase
    end
    // else hold state when not training
end

endmodule