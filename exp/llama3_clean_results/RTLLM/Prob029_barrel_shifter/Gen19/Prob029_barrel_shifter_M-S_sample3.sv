// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount directly from control bits
    assign out = (in >> (ctrl[2] * 4 + ctrl[1] * 2 + ctrl[0]));

endmodule

// Simplified testbench
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

        // Test shifts
        in = 8'b11010011;
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        #10;
        $finish;
    end
endmodule