module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: initialize counter to zero
        Q <= 64'b0;
    end else begin
        // Shift left by one and insert inverted MSB at LSB
        // Johnson counter operation with reversed shift direction:
        // If Q[63] == 0, insert 1 at LSB; if Q[63] == 1, insert 0 at LSB.
        Q <= {Q[62:0], ~Q[63]};
    end
end

endmodule