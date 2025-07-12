// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Perform circular shifts based on control signal
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions
    assign shift4 = (ctrl[2]) ? {in[3:0], in[7:4]} : in;

    // Stage 2: Shift by 2 positions
    assign shift2 = (ctrl[1]) ? {shift4[5:0], shift4[7:6]} : shift4;

    // Stage 3: Shift by 1 position
    assign shift1 = (ctrl[0]) ? {shift2[6:0], shift2[7]} : shift2;

    // Output the final shifted value
    assign out = shift1;

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