// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Perform circular shifts based on control signal
    wire [7:0] shift_1, shift_2, shift_4;

    // Shift by 1 position
    assign shift_1 = {in[6:0], in[7]};

    // Shift by 2 positions
    assign shift_2 = {in[5:0], in[7:6]};

    // Shift by 4 positions
    assign shift_4 = {in[3:0], in[7:4]};

    // Select the correct shifted version based on the control signal
    assign out[0] = ctrl[0]? shift_1[0] : (ctrl[1]? shift_2[0] : (ctrl[2]? shift_4[0] : in[0]));
    assign out[1] = ctrl[0]? shift_1[1] : (ctrl[1]? shift_2[1] : (ctrl[2]? shift_4[1] : in[1]));
    assign out[2] = ctrl[0]? shift_1[2] : (ctrl[1]? shift_2[2] : (ctrl[2]? shift_4[2] : in[2]));
    assign out[3] = ctrl[0]? shift_1[3] : (ctrl[1]? shift_2[3] : (ctrl[2]? shift_4[3] : in[3]));
    assign out[4] = ctrl[0]? shift_1[4] : (ctrl[1]? shift_2[4] : (ctrl[2]? shift_4[4] : in[4]));
    assign out[5] = ctrl[0]? shift_1[5] : (ctrl[1]? shift_2[5] : (ctrl[2]? shift_4[5] : in[5]));
    assign out[6] = ctrl[0]? shift_1[6] : (ctrl[1]? shift_2[6] : (ctrl[2]? shift_4[6] : in[6]));
    assign out[7] = ctrl[0]? shift_1[7] : (ctrl[1]? shift_2[7] : (ctrl[2]? shift_4[7] : in[7]));

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