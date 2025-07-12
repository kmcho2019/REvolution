module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial begin
    q = 3'b100; // Initialize to 4 when a=1
end

always @(posedge clk) begin
    if (a) begin
        q <= q; // Hold value when a is high
    end else begin
        q <= (q == 3'b110) ? 3'b000 : q + 1; // Increment with wrap-around
    end
end

endmodule