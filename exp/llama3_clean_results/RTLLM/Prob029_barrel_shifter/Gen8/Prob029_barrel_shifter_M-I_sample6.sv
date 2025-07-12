// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    // Stage for shifting by 4 positions
    wire [7:0] stage1_out = (ctrl[2])? {in[3:0], 4'b0000} : in;

    // Stage for shifting by 2 positions
    wire [7:0] stage2_out = (ctrl[1])? {stage1_out[5:0], 2'b00} : stage1_out;

    // Stage for shifting by 1 position
    assign out = (ctrl[0])? {stage2_out[6:0], stage2_out[7]} : stage2_out;
endmodule

// Define the mux2x1 module
module mux2x1(
    input [7:0] in0,  // Input 0
    input [7:0] in1,  // Input 1
    input sel,  // Select signal
    output [7:0] out  // Output
);
    assign out = (sel)? in1 : in0;
endmodule

// Define the barrel_shifter_module module
module barrel_shifter_module(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    // Stage for shifting by 4 positions
    mux2x1 stage1_mux(
       .in0(in),
       .in1({in[3:0], 4'b0000}),
       .sel(ctrl[2]),
       .out(stage1_out)
    );

    // Stage for shifting by 2 positions
    mux2x1 stage2_mux(
       .in0(stage1_out),
       .in1({stage1_out[5:0], 2'b00}),
       .sel(ctrl[1]),
       .out(stage2_out)
    );

    // Stage for shifting by 1 position
    mux2x1 stage3_mux(
       .in0(stage2_out),
       .in1({stage2_out[6:0], stage2_out[7]}),
       .sel(ctrl[0]),
       .out(stage3_out)
    );

    assign out = stage3_out;
endmodule

// Testbench for the barrel_shifter_module module
module barrel_shifter_module_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter_module uut (
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