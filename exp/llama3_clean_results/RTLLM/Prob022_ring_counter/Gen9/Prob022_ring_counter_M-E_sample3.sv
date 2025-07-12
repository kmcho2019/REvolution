module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        shift_reg <= 8'b00000001;
    end else begin
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
end

always @(*) begin
    case(shift_reg)
        8'b00000001: out = 8'b00000001;
        8'b00000010: out = 8'b00000010;
        8'b00000100: out = 8'b00000100;
        8'b00001000: out = 8'b00001000;
        8'b00010000: out = 8'b00010000;
        8'b00100000: out = 8'b00100000;
        8'b01000000: out = 8'b01000000;
        8'b10000000: out = 8'b10000000;
        default: out = 8'b00000000;
    endcase
end

endmodule