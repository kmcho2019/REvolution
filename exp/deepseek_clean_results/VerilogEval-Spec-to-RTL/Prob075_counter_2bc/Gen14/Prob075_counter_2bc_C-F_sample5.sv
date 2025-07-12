module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;  // Async reset to weakly not-taken
    end
    else if (train_valid) begin
        if (train_taken) begin
            state <= (state == S3) ? S3 : state + 1;  // Increment with saturation
        end
        else begin
            state <= (state == S0) ? S0 : state - 1;  // Decrement with saturation
        end
    end
    // else hold state (implicit)
end

endmodule