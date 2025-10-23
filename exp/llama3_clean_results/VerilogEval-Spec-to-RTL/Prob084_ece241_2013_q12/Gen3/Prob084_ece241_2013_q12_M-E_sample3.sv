module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

wire [2:0] addr = {A, B, C};
reg [7:0] dec_out;

always @(*) begin
    case (addr)
        3'b000: dec_out = 8'b00000001;
        3'b001: dec_out = 8'b00000010;
        3'b010: dec_out = 8'b00000100;
        3'b011: dec_out = 8'b00001000;
        3'b100: dec_out = 8'b00010000;
        3'b101: dec_out = 8'b00100000;
        3'b110: dec_out = 8'b01000000;
        3'b111: dec_out = 8'b10000000;
        default: dec_out = 8'b00000000;
    endcase
end

assign Z = (dec_out[0] ? Q[0] :
            dec_out[1] ? Q[1] :
            dec_out[2] ? Q[2] :
            dec_out[3] ? Q[3] :
            dec_out[4] ? Q[4] :
            dec_out[5] ? Q[5] :
            dec_out[6] ? Q[6] :
            dec_out[7] ? Q[7] : 1'bx);

endmodule