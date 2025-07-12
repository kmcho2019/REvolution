module TopModule(in, out);
    input [2:0] in;
    output [1:0] out;

    reg [1:0] temp;

    always @(in) begin
        case (in)
            3'b000: temp = 2'b00;
            3'b001, 3'b010, 3'b100: temp = 2'b01;
            3'b011, 3'b101, 3'b110: temp = 2'b10;
            3'b111: temp = 2'b11;
        endcase
    end

    assign out = temp;
endmodule