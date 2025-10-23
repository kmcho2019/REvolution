module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low asynchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// Feedback bit is the inverse of the MSB
wire feedback_bit = ~Q[63];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;                       // Reset counter to zero
    else
        Q <= {Q[62:0], feedback_bit};    // Shift left and insert feedback at LSB
end

endmodule