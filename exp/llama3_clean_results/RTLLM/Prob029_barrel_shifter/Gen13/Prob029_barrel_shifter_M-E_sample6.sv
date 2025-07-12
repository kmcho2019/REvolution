// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define the shifted inputs
    wire [7:0] shift1, shift2, shift4;

    // Shift by 1 position
    assign shift1 = {in[6:0], in[7]};

    // Shift by 2 positions
    assign shift2 = {in[5:0], in[7:6]};

    // Shift by 4 positions
    assign shift4 = {in[3:0], in[7:4]};

    // Use multiplexers to select the correct shifted output
    wire [7:0] mux_out1, mux_out2;

    // Select between shift4 and original input
    assign mux_out1 = (ctrl[2])? shift4 : in;

    // Select between shift2 and mux_out1
    assign mux_out2 = (ctrl[1])? shift2 : mux_out1;

    // Select between shift1 and mux_out2
    assign out = (ctrl[0])? shift1 : mux_out2;

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