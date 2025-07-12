module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

reg [2:0] ptr;

initial begin
    q = 8'b0;
    ptr = 3'b111; // Start at MSB (bit 7)
end

always @(posedge clk) begin
    q[ptr] <= d;       // Insert new bit at current pointer
    ptr <= ptr - 1;    // Move pointer right (with wrap-around)
end

endmodule