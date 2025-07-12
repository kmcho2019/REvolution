module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        case (q)
            3'b000: q <= 1;
            3'b001: q <= 2;
            3'b010: q <= 3;
            3'b011: q <= 4;
            3'b100: q <= 5;
            3'b101: q <= 6;
            3'b110: q <= 0;
            3'b111: q <= 0;
            default: q <= 4;
        endcase
    end
end

endmodule