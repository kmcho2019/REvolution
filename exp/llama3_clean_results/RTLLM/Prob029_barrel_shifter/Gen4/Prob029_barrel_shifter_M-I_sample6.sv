// Define the mux2X1 submodule
module mux2X1 #(
    parameter WIDTH = 8  // Width of the input
)(
    input [WIDTH-1:0] in0,  // First input
    input [WIDTH-1:0] in1,  // Second input
    input sel,  // Select signal
    output [WIDTH-1:0] out  // Output
);
    assign out = sel ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter #(
    parameter WIDTH = 8,  // Width of the input
    parameter CTRL_WIDTH = 3  // Width of the control signal
)(
    input [WIDTH-1:0] in,  // Input to be shifted
    input [CTRL_WIDTH-1:0] ctrl,  // Control signal
    output [WIDTH-1:0] out  // Shifted output
);
    // Shift by 4 positions
    wire [WIDTH-1:0] shift4;
    mux2X1 #(.WIDTH(WIDTH)) shift4_mux (
        .in0(in),
        .in1({in[3:0], 4'b0000}),
        .sel(ctrl[2]),
        .out(shift4)
    );

    // Shift by 2 positions
    wire [WIDTH-1:0] shift2;
    mux2X1 #(.WIDTH(WIDTH)) shift2_mux (
        .in0(shift4),
        .in1({shift4[6:0], 2'b00}),
        .sel(ctrl[1]),
        .out(shift2)
    );

    // Shift by 1 position
    wire [WIDTH-1:0] shift1;
    mux2X1 #(.WIDTH(WIDTH)) shift1_mux (
        .in0(shift2),
        .in1({shift2[7:1], 1'b0}),
        .sel(ctrl[0]),
        .out(shift1)
    );

    assign out = shift1;
endmodule

// Testbench for the barrel_shifter module
module barrel_shifter_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter #(
        .WIDTH(8),
        .CTRL_WIDTH(3)
    ) uut (
       .in(in),
       .ctrl(ctrl),
       .out(out)
    );

    initial begin
        in = 8'b11010011;
        ctrl = 3'b001;
        #10;
        $display("Output: %b", out);
        ctrl = 3'b010;
        #10;
        $display("Output: %b", out);
        ctrl = 3'b100;
        #10;
        $display("Output: %b", out);
    end
endmodule