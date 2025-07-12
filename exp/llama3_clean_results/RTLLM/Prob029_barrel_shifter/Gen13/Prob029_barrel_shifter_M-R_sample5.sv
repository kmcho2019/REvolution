// Define a module for shifting by 1 position
module shift_by_1(
    input [7:0] in,  // Input to be shifted
    input shift,     // Shift control signal
    output [7:0] out  // Shifted output
);
    assign out = (shift)? {in[6:0], in[7]} : in;
endmodule

// Define a module for shifting by 2 positions
module shift_by_2(
    input [7:0] in,  // Input to be shifted
    input shift,     // Shift control signal
    output [7:0] out  // Shifted output
);
    assign out = (shift)? {in[5:0], in[7:6]} : in;
endmodule

// Define a module for shifting by 4 positions
module shift_by_4(
    input [7:0] in,  // Input to be shifted
    input shift,     // Shift control signal
    output [7:0] out  // Shifted output
);
    assign out = (shift)? {in[3:0], in[7:4]} : in;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    wire [7:0] shift4, shift2;

    // Stage 1: Shift by 4 positions
    shift_by_4 stage1(
       .in(in),
       .shift(ctrl[2]),
       .out(shift4)
    );

    // Stage 2: Shift by 2 positions
    shift_by_2 stage2(
       .in(shift4),
       .shift(ctrl[1]),
       .out(shift2)
    );

    // Stage 3: Shift by 1 position
    shift_by_1 stage3(
       .in(shift2),
       .shift(ctrl[0]),
       .out(out)
    );
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
        $dumpfile("dump.vcd");
        $dumpvars;
        in = 8'b11010011;

        // Test all possible combinations of the control signal
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output (ctrl = %b): %b", ctrl, out);
        end

        #10;
        $finish;
    end
endmodule