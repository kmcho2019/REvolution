module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount based on the control bits
    wire [2:0] shift_amount = (ctrl[2] << 2) + (ctrl[1] << 1) + ctrl[0];

    // Perform the shift in a single operation using optimized primitives
    assign out = in >> shift_amount;

endmodule

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

        // Test no shift
        in = 8'b11010011;
        ctrl = 3'b000;  
        #10;
        $display("Output (no shift): %b", out);

        // Test shifts by 1, 2, 4, and combinations
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        // Test with varying inputs and control signals
        in = 8'b10101010;
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
        end

        #10;
        $finish;
    end
endmodule