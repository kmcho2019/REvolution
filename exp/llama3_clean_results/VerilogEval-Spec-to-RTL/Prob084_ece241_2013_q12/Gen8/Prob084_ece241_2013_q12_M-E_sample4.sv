module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;
reg [2:0] addr;

// Priority encoder
always @(*) begin
    case ({A, B, C})
        3'b000: addr = 3'b000;
        3'b001: addr = 3'b001;
        3'b010: addr = 3'b010;
        3'b011: addr = 3'b011;
        3'b100: addr = 3'b100;
        3'b101: addr = 3'b101;
        3'b110: addr = 3'b110;
        3'b111: addr = 3'b111;
        default: addr = 3'b000;
    endcase
end

// Binary-to-1-of-8 decoder
wire [7:0] sel;
assign sel[0] = (addr == 3'b000) ? 1'b1 : 1'b0;
assign sel[1] = (addr == 3'b001) ? 1'b1 : 1'b0;
assign sel[2] = (addr == 3'b010) ? 1'b1 : 1'b0;
assign sel[3] = (addr == 3'b011) ? 1'b1 : 1'b0;
assign sel[4] = (addr == 3'b100) ? 1'b1 : 1'b0;
assign sel[5] = (addr == 3'b101) ? 1'b1 : 1'b0;
assign sel[6] = (addr == 3'b110) ? 1'b1 : 1'b0;
assign sel[7] = (addr == 3'b111) ? 1'b1 : 1'b0;

// Shift register
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Output logic
always @(*) begin
    Z = (Q[0] & sel[0]) | (Q[1] & sel[1]) | (Q[2] & sel[2]) | (Q[3] & sel[3]) |
        (Q[4] & sel[4]) | (Q[5] & sel[5]) | (Q[6] & sel[6]) | (Q[7] & sel[7]);
end

endmodule