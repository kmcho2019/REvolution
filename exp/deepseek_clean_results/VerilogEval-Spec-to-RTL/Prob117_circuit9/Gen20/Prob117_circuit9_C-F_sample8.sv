module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire enable = ~a;  // Only update counter when a is low

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Fixed value when a is high
    end
    else if (enable) begin
        case (q)
            3'b000: q <= 3'b001;  // 0 -> 1
            3'b001: q <= 3'b010;  // 1 -> 2
            3'b010: q <= 3'b011;  // 2 -> 3
            3'b011: q <= 3'b100;  // 3 -> 4
            3'b100: q <= 3'b101;  // 4 -> 5
            3'b101: q <= 3'b110;  // 5 -> 6
            3'b110: q <= 3'b000;  // 6 -> 0
        endcase
    end
end

endmodule