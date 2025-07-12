module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Split the 8-bit input into two 4-bit segments
    wire [3:0] in_segment1 = in[7:4];
    wire [3:0] in_segment2 = in[3:0];

    // Lookup tables for shifting within each segment
    wire [3:0] shifted_segment1;
    wire [3:0] shifted_segment2;

    always @(in_segment1, ctrl) begin
        case (ctrl[2:0])
            3'b000: shifted_segment1 = in_segment1;
            3'b001: shifted_segment1 = {in_segment1[2:0], 1'b0};
            3'b010: shifted_segment1 = {in_segment1[1:0], 2'b00};
            3'b011: shifted_segment1 = {in_segment1[0], 3'b000};
            3'b100: shifted_segment1 = {4'b0000, in_segment1[3]};
            3'b101: shifted_segment1 = {3'b000, in_segment1[3:1]};
            3'b110: shifted_segment1 = {2'b00, in_segment1[3:2]};
            3'b111: shifted_segment1 = {1'b0, in_segment1[3:0]};
            default: shifted_segment1 = in_segment1;
        endcase
    end

    always @(in_segment2, ctrl) begin
        case (ctrl[2:0])
            3'b000: shifted_segment2 = in_segment2;
            3'b001: shifted_segment2 = {in_segment2[2:0], 1'b0};
            3'b010: shifted_segment2 = {in_segment2[1:0], 2'b00};
            3'b011: shifted_segment2 = {in_segment2[0], 3'b000};
            3'b100: shifted_segment2 = {4'b0000, in_segment2[3]};
            3'b101: shifted_segment2 = {3'b000, in_segment2[3:1]};
            3'b110: shifted_segment2 = {2'b00, in_segment2[3:2]};
            3'b111: shifted_segment2 = {1'b0, in_segment2[3:0]};
            default: shifted_segment2 = in_segment2;
        endcase
    end

    // Combine the shifted segments
    assign out = {shifted_segment1, shifted_segment2};

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
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift
        #10;
        $display("Output (no shift): %b", out);

        in = 8'b11010011;
        ctrl = 3'b001;  // Test shift by 1
        #10;
        $display("Output (shift by 1): %b", out);

        in = 8'b11010011;
        ctrl = 3'b010;  // Test shift by 2
        #10;
        $display("Output (shift by 2): %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b011;  // Test shift by 3 (1+2)
        #10;
        $display("Output (shift by 3): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 5 (1+4)
        #10;
        $display("Output (shift by 5): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 6 (2+4)
        #10;
        $display("Output (shift by 6): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 7 (1+2+4)
        #10;
        $display("Output (shift by 7): %b", out);

        // Additional test cases for comprehensive coverage
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift with different input
        in = 8'b10101010;
        #10;
        $display("Output (no shift, different input): %b", out);

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        #10;
        $finish;
    end
endmodule