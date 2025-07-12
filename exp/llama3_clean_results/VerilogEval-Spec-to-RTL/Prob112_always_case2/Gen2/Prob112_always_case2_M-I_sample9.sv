module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        casez (in)
            4'b1000: pos = 2'b11;
            4'b100:  pos = 2'b10;
            4'b10:   pos = 2'b01;
            4'b1:    pos = 2'b00;
            default: pos = 2'b00;
        endcase
    end

endmodule

module testbench;
    reg [3:0] in;
    wire [1:0] pos;

    TopModule uut (
        .in(in),
        .pos(pos)
    );

    initial begin
        in = 4'b0000;
        #10;
        $display("Input: %b, Output: %b", in, pos);

        for (int i = 1; i < 16; i++) begin
            in = i;
            #10;
            $display("Input: %b, Output: %b", in, pos);
        end
    end
endmodule