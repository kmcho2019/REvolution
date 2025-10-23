// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,        // Select signal
    output [7:0] out  // Output
);
    assign out = sel ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(
        .in0(in),
        .in1({in[3:0], 4'b0000}),  // Shift in by 4 positions
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(
        .in0(stage1_out),
        .in1({stage1_out[5:0], 2'b00}),  // Shift stage1_out by 2 positions
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_out;
    mux2X1 stage3_mux(
        .in0(stage2_out),
        .in1({stage2_out[6:0], 1'b0}),  // Shift stage2_out by 1 position
        .sel(ctrl[0]),
        .out(stage3_out)
    );

    // Assign the final output
    assign out = stage3_out;

endmodule

// Define the testbench
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
        
        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            in = 8'b11010011;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        // Test with varying inputs and control signals
        for (int i = 0; i < 256; i++) begin
            in = i;
            for (int j = 0; j < 8; j++) begin
                ctrl = j;
                #10;
                $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
            end
        end

        #10;
        $finish;
    end
endmodule