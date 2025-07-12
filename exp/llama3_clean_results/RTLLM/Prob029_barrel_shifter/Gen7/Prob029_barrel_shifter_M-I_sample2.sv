// Define the mux8X1 submodule
module mux8X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input [7:0] in2,  // Third input
    input [7:0] in3,  // Fourth input
    input [7:0] in4,  // Fifth input
    input [7:0] in5,  // Sixth input
    input [7:0] in6,  // Seventh input
    input [7:0] in7,  // Eighth input
    input [2:0] sel,   // Select signal
    output [7:0] out   // Output
);
    always @(*) begin
        case (sel)
            3'b000: out = in0;
            3'b001: out = in1;
            3'b010: out = in2;
            3'b011: out = in3;
            3'b100: out = in4;
            3'b101: out = in5;
            3'b110: out = in6;
            3'b111: out = in7;
            default: out = 8'b0;
        endcase
    end
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output reg [7:0] out  // Shifted output
);
    wire [7:0] shift0;
    wire [7:0] shift1;
    wire [7:0] shift2;
    wire [7:0] shift3;
    wire [7:0] shift4;
    wire [7:0] shift5;
    wire [7:0] shift6;
    wire [7:0] shift7;

    // Calculate the shifted inputs
    assign shift0 = in;
    assign shift1 = {in[6:0], in[7]};
    assign shift2 = {in[5:0], in[7:6]};
    assign shift3 = {in[4:0], in[7:5]};
    assign shift4 = {in[3:0], in[7:4]};
    assign shift5 = {in[2:0], in[7:3]};
    assign shift6 = {in[1:0], in[7:2]};
    assign shift7 = {in[0], in[7:1]};

    // Instantiate the mux8X1 submodule
    mux8X1 barrel_shifter_mux(
       .in0(shift0),
       .in1(shift1),
       .in2(shift2),
       .in3(shift3),
       .in4(shift4),
       .in5(shift5),
       .in6(shift6),
       .in7(shift7),
       .sel(ctrl),
       .out(out)
    );
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