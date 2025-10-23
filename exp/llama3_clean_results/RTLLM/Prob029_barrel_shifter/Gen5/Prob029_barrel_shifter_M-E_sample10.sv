// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    always @(*) begin
        case(ctrl)
            3'b000: out = in;  // No shift
            3'b001: out = {in[6:0], in[7]};  // Shift by 1
            3'b010: out = {in[5:0], in[7:6]};  // Shift by 2
            3'b011: out = {in[5:0], in[7:5]};  // Shift by 3
            3'b100: out = {in[3:0], in[7:4]};  // Shift by 4
            3'b101: out = {in[3:0], in[7:3]};  // Shift by 5
            3'b110: out = {in[2:0], in[7:2]};  // Shift by 6
            3'b111: out = {in[1:0], in[7:1]};  // Shift by 7
            default: out = in;  // Default: no shift
        endcase
    end
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
        ctrl = 3'b011;  // Test shift by 3
        #10;
        $display("Output (shift by 3): %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 5
        #10;
        $display("Output (shift by 5): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 6
        #10;
        $display("Output (shift by 6): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 7
        #10;
        $display("Output (shift by 7): %b", out);
    end
endmodule