module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Reset to 4 when 'a' is high
    end else begin
        // Shift-left with wrap-around for increment
        q <= {q[1:0], ~(q[2] & q[1] & q[0])};
    end
end

endmodule