// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define the 2-to-1 multiplexer submodule
    module mux2x1(
        input [7:0] a,  // First input
        input [7:0] b,  // Second input
        input sel,  // Select signal
        output [7:0] out  // Output
    );
        assign out = sel ? b : a;
    endmodule

    // First level of multiplexers (shift by 4)
    wire [7:0] level1_out0, level1_out1;
    mux2x1 level1_mux0(
        .a(in),
        .b({in[3:0], 4'b0000}),
        .sel(ctrl[2]),
        .out(level1_out0)
    );
    mux2x1 level1_mux1(
        .a(in),
        .b({in[3:0], 4'b0000}),
        .sel(ctrl[2]),
        .out(level1_out1)
    );

    // Second level of multiplexers (shift by 2)
    wire [7:0] level2_out0, level2_out1;
    mux2x1 level2_mux0(
        .a(level1_out0),
        .b({level1_out0[5:0], 2'b00}),
        .sel(ctrl[1]),
        .out(level2_out0)
    );
    mux2x1 level2_mux1(
        .a(level1_out1),
        .b({level1_out1[5:0], 2'b00}),
        .sel(ctrl[1]),
        .out(level2_out1)
    );

    // Third level of multiplexers (shift by 1)
    wire [7:0] level3_out0, level3_out1;
    mux2x1 level3_mux0(
        .a(level2_out0),
        .b({level2_out0[6:0], 1'b0}),
        .sel(ctrl[0]),
        .out(level3_out0)
    );
    mux2x1 level3_mux1(
        .a(level2_out1),
        .b({level2_out1[6:0], 1'b0}),
        .sel(ctrl[0]),
        .out(level3_out1)
    );

    // Final output selection
    assign out = level3_out0;

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
        ctrl = 3'b000;  // Test no shift
        #10;
        $display("Output (no shift): %b", out);

        in = 8'b11010011;
        ctrl = 3'b001;  // Test shift by 1
        #10;
        $display("Output (shift by 1): %b", out);

        in = 8'b11010011;
        ctrl = 3'b010;  // Test shift by 2
        #10;
        $display("Output (shift by 2): %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b011;  // Test shift by 3 (1+2)
        #10;
        $display("Output (shift by 3): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 5 (1+4)
        #10;
        $display("Output (shift by 5): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 6 (2+4)
        #10;
        $display("Output (shift by 6): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 7 (1+2+4)
        #10;
        $display("Output (shift by 7): %b", out);

        // Additional test cases for comprehensive coverage
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift with different input
        in = 8'b10101010;
        #10;
        $display("Output (no shift, different input): %b", out);

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        #10;
        $finish;
    end
endmodule