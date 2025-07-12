// Improved barrel_shifter module with optimizations
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount directly from control bits
    // Using a more efficient encoding for the control signal
    wire [2:0] shift_amount;
    assign shift_amount = {ctrl[2] * 4, ctrl[1] * 2, ctrl[0]};

    // Pipelining the shift operation for better performance
    reg [7:0] shifted_in;
    always @(posedge ctrl or posedge in) begin
        shifted_in <= in;
        for (int i = 0; i < shift_amount; i++) begin
            shifted_in <= shifted_in >> 1;
        end
    end

    // Output the shifted result
    assign out = shifted_in;

    // Clock gating for power optimization
    reg clock_enable;
    always @(posedge ctrl) begin
        clock_enable <= 1'b1;
    end
    always @(negedge ctrl) begin
        clock_enable <= 1'b0;
    end

    // Operand isolation for further power reduction
    reg [7:0] isolated_in;
    always @(posedge clock_enable) begin
        isolated_in <= in;
    end

    // Using isolated input for shifting
    assign shifted_in = isolated_in;

endmodule

// Comprehensive testbench remains largely the same with additional test cases
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
        ctrl = 3'b000;  // Test no shift
        #10;
        $display("Output (no shift): %b", out);

        // Additional test cases for comprehensive coverage
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        // Test all possible combinations of control bits with different inputs
        for (int j = 0; j < 256; j++) begin
            in = j;
            for (int i = 0; i < 8; i++) begin
                ctrl = i;
                #10;
                $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
            end
        end

        #10;
        $finish;
    end
endmodule