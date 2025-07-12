module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    reg [7:0] temp;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    assign temp = (ctrl[2]) ? {in[3:0], 4'b0000} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    reg [7:0] temp2;
    assign temp2 = (ctrl[1]) ? {temp[5:0], 2'b00} : temp;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign out = (ctrl[0]) ? {temp2[6:0], temp2[7]} : temp2;

endmodule

// Testbench for the barrel_shifter module
module barrel_shifter_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter uut (
        .in(in),
        .ctrl(ctrl),
        .out(out)
    );

    initial begin
        in = 8'b11010011;
        ctrl = 3'b001;
        #10;
        $display("Output: %b", out);

        in = 8'b11010011;
        ctrl = 3'b010;
        #10;
        $display("Output: %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;
        #10;
        $display("Output: %b", out);
    end
endmodule