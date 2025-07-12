module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Stage 1: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage1_out;
    assign stage1_out = (ctrl[0]) ? {in[6:0], in[7]} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    assign stage2_out = (ctrl[1]) ? {stage1_out[5:0], stage1_out[7:6]} : stage1_out;

    // Stage 3: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage3_out;
    assign stage3_out = (ctrl[2]) ? {stage2_out[3:0], stage2_out[7:4]} : stage2_out;

    // Final output
    assign out = stage3_out;

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