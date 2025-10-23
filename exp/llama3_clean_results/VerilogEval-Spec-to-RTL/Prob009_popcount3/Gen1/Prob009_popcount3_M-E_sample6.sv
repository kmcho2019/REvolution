module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] count_2bit;
    wire [0:0] count_1bit;

    assign count_1bit = {1'b0} + in[0];
    assign count_2bit = (in[1]? 2'b01 : 2'b00) + (in[2]? 2'b01 : 2'b00);

    always @(*) begin
        case ({count_1bit, count_2bit})
            3'b000: out = 2'b00;
            3'b001, 3'b010: out = 2'b01;
            3'b011, 3'b100: out = 2'b10;
            3'b101, 3'b110, 3'b111: out = 2'b11;
        endcase
    end

endmodule