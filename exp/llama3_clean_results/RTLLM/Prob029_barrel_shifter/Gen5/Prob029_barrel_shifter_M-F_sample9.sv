// Define the barrel_shifter module
module barrel_shifter (
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define the mux2x1 submodule
    module mux2x1 #(
        parameter WIDTH = 8
    )(
        input [WIDTH-1:0] a,  // First input
        input [WIDTH-1:0] b,  // Second input
        input sel,  // Select signal
        output [WIDTH-1:0] out  // Output
    );
        assign out = sel? b : a;
    endmodule

    wire [7:0] stage1_out;  // Output of the first stage
    wire [7:0] stage2_out;  // Output of the second stage

    // Stage 1: Shift by 1 position
    mux2x1 #(
       .WIDTH(8)
    ) stage1 (
       .a(in),
       .b({in[6:0], 1'b0}),  // Shift input by 1 position
       .sel(ctrl[0]),
       .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions
    mux2x1 #(
       .WIDTH(8)
    ) stage2 (
       .a(stage1_out),
       .b({stage1_out[5:0], 2'b00}),  // Shift input by 2 positions
       .sel(ctrl[1]),
       .out(stage2_out)
    );

    // Stage 3: Shift by 4 positions
    mux2x1 #(
       .WIDTH(8)
    ) stage3 (
       .a(stage2_out),
       .b({stage2_out[3:0], 4'b0000}),  // Shift input by 4 positions
       .sel(ctrl[2]),
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
        ctrl = 3'b001;
        #10;
        $display("Output: %b", out);
        
        // Additional test cases
        #10;
        in = 8'b10101010;
        ctrl = 3'b010;
        #10;
        $display("Output: %b", out);
        
        #10;
        in = 8'b11001100;
        ctrl = 3'b100;
        #10;
        $display("Output: %b", out);
        
        #10;
        in = 8'b11110000;
        ctrl = 3'b111;
        #10;
        $display("Output: %b", out);
    end
endmodule