module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(negedge clk) begin
    if (reset) begin
        case (1'b1)
            1'b1: q <= 8'h34;
        endcase
    end else begin
        q <= d;
    end
end

endmodule