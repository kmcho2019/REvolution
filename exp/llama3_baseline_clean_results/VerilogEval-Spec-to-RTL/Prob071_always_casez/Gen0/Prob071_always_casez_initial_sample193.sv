module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

always @(*) begin
    pos = 3'b000;
    for (int i = 0; i < 8; i++) begin
        if (in[i]) begin
            pos = i;
            break;
        end
    end
end

endmodule

module tb_TopModule();
    reg [7:0] in;
    wire [2:0] pos;

    TopModule uut (
        .in  (in),
        .pos (pos)
    );

    initial begin
        $display("pos = %d", pos);
        in = 8'b10010000;
        #10;
        $display("pos = %d", pos);
        in = 8'b00000000;
        #10;
        $display("pos = %d", pos);
    end
endmodule