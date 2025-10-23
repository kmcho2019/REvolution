module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount based on the control bits
    wire [2:0] shift_amount;
    assign shift_amount = (ctrl[2] << 2) + (ctrl[1] << 1) + ctrl[0];

    // Perform the shift in a single operation
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