module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

// 8-bit shift register
reg [7:0] Q;
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// 3-to-8 decoder
wire [7:0] sel;
always @(*) begin
    case ({A, B, C})
        3'b000: sel = 8'b00000001;
        3'b001: sel = 8'b00000010;
        3'b010: sel = 8'b00000100;
        3'b011: sel = 8'b00001000;
        3'b100: sel = 8'b00010000;
        3'b101: sel = 8'b00100000;
        3'b110: sel = 8'b01000000;
        3'b111: sel = 8'b10000000;
        default: sel = 8'b00000000;
    endcase
end

// 8-to-1 multiplexer
assign Z = (Q[0] & sel[0]) | (Q[1] & sel[1]) | (Q[2] & sel[2]) | (Q[3] & sel[3]) |
           (Q[4] & sel[4]) | (Q[5] & sel[5]) | (Q[6] & sel[6]) | (Q[7] & sel[7]);

endmodule