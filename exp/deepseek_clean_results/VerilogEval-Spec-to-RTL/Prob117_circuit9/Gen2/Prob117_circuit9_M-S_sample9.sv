module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100  // Initialize to 4
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // Hold when a=1
    end else begin
        q <= (q == 3'b110) ? 3'b000 : q + 1;  // Increment with wrap-around
    end
end

endmodule