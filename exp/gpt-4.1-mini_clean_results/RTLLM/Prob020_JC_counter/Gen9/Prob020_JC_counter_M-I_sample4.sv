module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

// Synchronous active-high reset for timing stability
always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Shift left by one, new LSB is inverse of current MSB
        Q <= {Q[62:0], ~Q[63]};
    end
end

endmodule