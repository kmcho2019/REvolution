module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

always @(in) begin
    pos = 3'd0;
    if (in[0]) pos = 3'd0;
    else if (in[1]) pos = 3'd1;
    else if (in[2]) pos = 3'd2;
    else if (in[3]) pos = 3'd3;
    else if (in[4]) pos = 3'd4;
    else if (in[5]) pos = 3'd5;
    else if (in[6]) pos = 3'd6;
    else if (in[7]) pos = 3'd7;
end

endmodule

module testbench;
reg [7:0] in;
wire [2:0] pos;
TopModule dut (.in(in), .pos(pos));

initial begin
    in = 8'b10010000;
    $display("Input: %b, Output: %d", in, pos);
    #10 $finish;
end
endmodule