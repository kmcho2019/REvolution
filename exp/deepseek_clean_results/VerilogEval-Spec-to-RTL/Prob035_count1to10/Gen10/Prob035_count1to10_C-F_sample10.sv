module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    case ({reset, q[3] & q[1]})
        2'b10: q <= 4'b0001;    // Reset condition (highest priority)
        2'b01: q <= 4'b0001;    // Wrap condition (value 10)
        default: q <= q + 1;    // Normal increment
    endcase
end

endmodule