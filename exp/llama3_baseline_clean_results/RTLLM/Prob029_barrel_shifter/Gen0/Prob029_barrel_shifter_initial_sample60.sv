// Define the 2-to-1 multiplexer submodule
module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires for each stage
    wire [7:0] shift4, shift2, shift1;

    // Stage for shifting by 4 positions based on ctrl[2]
    mux2X1 #(.WIDTH(8)) mux4(ctrl[2], in, {in[3:0], 4'b0000}, shift4);

    // Stage for shifting by 2 positions based on ctrl[1]
    mux2X1 #(.WIDTH(8)) mux2(ctrl[1], shift4, {shift4[5:0], 2'b00}, shift2);

    // Stage for shifting by 1 position based on ctrl[0]
    mux2X1 #(.WIDTH(8)) mux1(ctrl[0], shift2, {shift2[6:0], 1'b0}, shift1);

    // Final output is the result of the last stage
    assign out = shift1;
endmodule

// Testbench for the barrel shifter (optional, for demonstration purposes)
module test_barrel_shifter();
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter uut(in, ctrl, out);

    initial begin
        $dumpvars;
        in = 8'b11010101;
        ctrl = 3'b101; // Example control signal
        #100;
        $display("Output: %b", out);
        $finish;
    end
endmodule