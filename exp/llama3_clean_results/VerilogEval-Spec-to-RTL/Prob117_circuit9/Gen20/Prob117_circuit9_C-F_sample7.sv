module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 4; // Reset to 4 when a is high
    end else begin
        case (q)
            3'b000: next_q = 1;
            3'b001: next_q = 2;
            3'b010: next_q = 3;
            3'b011: next_q = 4;
            3'b100: next_q = 5;
            3'b101: next_q = 6;
            3'b110: next_q = 0;
            3'b111: next_q = 0;
            default: next_q = 4;
        endcase
    end
end

always @(posedge clk) begin
    q <= next_q;
end

initial q = 4;

endmodule