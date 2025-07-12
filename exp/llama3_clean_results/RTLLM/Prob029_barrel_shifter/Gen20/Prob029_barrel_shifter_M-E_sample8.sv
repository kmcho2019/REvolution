module recursive_barrel_shifter(
    input  [7:0] in,   // Input to be shifted
    input  [2:0] ctrl, // Control signal
    output [7:0] out  // Shifted output
);

    // Stage 1: Shift by 1
    wire [7:0] stage1_out;
    assign stage1_out = (ctrl[0] == 1'b1)? {in[6:0], 1'b0} : in;

    // Stage 2: Shift by 2
    wire [7:0] stage2_out;
    assign stage2_out = (ctrl[1] == 1'b1)? {stage1_out[5:0], 2'b00} : stage1_out;

    // Stage 3: Shift by 4
    wire [7:0] stage3_out;
    assign stage3_out = (ctrl[2] == 1'b1)? {stage2_out[3:0], 4'b0000} : stage2_out;

    // Final output
    assign out = stage3_out;

endmodule

module recursive_barrel_shifter_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    recursive_barrel_shifter uut (
       .in(in),
       .ctrl(ctrl),
       .out(out)
    );

    initial begin
        // Initialize input and control signals
        in = 8'b11010011;
        ctrl = 3'b000; // Test no shift

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("For ctrl = %b, Output: %b", ctrl, out);
        end

        // Test with different input values
        for (int i = 0; i < 256; i++) begin
            in = i;
            ctrl = 3'b111; // Test shift by 7
            #10;
            $display("For in = %b and ctrl = %b, Output: %b", in, ctrl, out);
        end

        // Additional test cases for comprehensive coverage
        for (int i = 0; i < 256; i++) begin
            in = i;
            for (int j = 0; j < 8; j++) begin
                ctrl = j;
                #10;
                $display("For in = %b and ctrl = %b, Output: %b", in, ctrl, out);
            end
        end

        #10;
        $finish;
    end
endmodule