// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount directly from control bits
    reg [2:0] shift_amount;
    always @(ctrl) begin
        shift_amount = ctrl[2] * 4 + ctrl[1] * 2 + ctrl[0];
    end

    // Use a series of assign statements with conditional expressions
    // to determine the output at each bit position
    assign out[0] = (in[7 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[1] = (in[6 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[2] = (in[5 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[3] = (in[4 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[4] = (in[3 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[5] = (in[2 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[6] = (in[1 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;
    assign out[7] = (in[0 - shift_amount] == 1'b1) ? 1'b1 : 1'b0;

endmodule

// Comprehensive testbench
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