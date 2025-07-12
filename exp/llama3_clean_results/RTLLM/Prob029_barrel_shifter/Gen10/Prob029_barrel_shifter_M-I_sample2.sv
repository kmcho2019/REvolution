// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Perform circular shifts based on control signal
    assign out = {in[7-ctrl:0], in[7:8-ctrl]};

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