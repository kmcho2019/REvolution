// D-flip-flop module
module D_flip_flop (
    input       clk,        // Clock signal
    input       rst,        // Active high reset signal
    input       d,          // Data input
    output reg  q           // Output
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Linear Feedback Shift Register (LFSR) module
module LFSR (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

// Calculate feedback by XORing the most significant and second most significant bits
assign feedback = out[3] ^ out[2];

// Instantiate four D-flip-flops for each bit of the LFSR
D_flip_flop uut_3 (.clk(clk),.rst(rst),.d(out[2]),.q(out[3]));
D_flip_flop uut_2 (.clk(clk),.rst(rst),.d(out[1]),.q(out[2]));
D_flip_flop uut_1 (.clk(clk),.rst(rst),.d(out[0]),.q(out[1]));
D_flip_flop uut_0 (.clk(clk),.rst(rst),.d(feedback),.q(out[0]));

endmodule

// Example testbench for verification
module LFSR_testbench;
    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR uut (
       .clk(clk),
       .rst(rst),
       .out(out)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #100;
        $finish;
    end

    initial begin
        $dumpvars();
        $dumpfile("LFSR.vcd");
    end

endmodule