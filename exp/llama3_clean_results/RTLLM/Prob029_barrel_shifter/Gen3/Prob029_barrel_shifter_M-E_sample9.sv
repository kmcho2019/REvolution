// Define the barrel_shifter module
module barrel_shifter #(
    parameter WIDTH = 8,  // Width of the input
    parameter CTRL_WIDTH = 3  // Width of the control signal
)(
    input [WIDTH-1:0] in,  // Input to be shifted
    input [CTRL_WIDTH-1:0] ctrl,  // Control signal
    output [WIDTH-1:0] out  // Shifted output
);

    // Perform the shifting operation
    assign out = in << ctrl;

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
    end
endmodule