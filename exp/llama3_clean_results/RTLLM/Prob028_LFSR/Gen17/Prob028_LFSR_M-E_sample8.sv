module LFSR_Galois (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

// Taps for the Galois LFSR (example for a 4-bit maximal-length sequence)
wire tap1 = out[3];
wire tap2 = out[1];

// State update logic for the Galois LFSR
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize state to a non-zero value for maximal-length sequence generation
        out <= 4'b1000;
    end else begin
        // Update state based on the Galois configuration
        out <= {out[2:0], tap1 ^ tap2};
    end
end

endmodule

// Example testbench for verification
module LFSR_Galois_testbench;
    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR_Galois uut (
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
        $monitor("%g: out = %b", $time, out);
    end

endmodule