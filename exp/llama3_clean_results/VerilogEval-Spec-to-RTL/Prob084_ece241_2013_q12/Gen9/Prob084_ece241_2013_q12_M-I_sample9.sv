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

// Shift register with clock gating
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// 3-to-8 decoder using one-hot encoding
wire [7:0] dec_out;
always @(*) begin
    case ({A, B, C})
        3'b000: dec_out = 8'b10000000;
        3'b001: dec_out = 8'b01000000;
        3'b010: dec_out = 8'b00100000;
        3'b011: dec_out = 8'b00010000;
        3'b100: dec_out = 8'b00001000;
        3'b101: dec_out = 8'b00000100;
        3'b110: dec_out = 8'b00000010;
        3'b111: dec_out = 8'b00000001;
        default: dec_out = 8'b00000000;
    endcase
end

// 8-to-1 multiplexer using case statement
always @(*) begin
    case ({A, B, C})
        3'b000: Z = Q[0];
        3'b001: Z = Q[1];
        3'b010: Z = Q[2];
        3'b011: Z = Q[3];
        3'b100: Z = Q[4];
        3'b101: Z = Q[5];
        3'b110: Z = Q[6];
        3'b111: Z = Q[7];
        default: Z = 1'b0;
    endcase
end

endmodule