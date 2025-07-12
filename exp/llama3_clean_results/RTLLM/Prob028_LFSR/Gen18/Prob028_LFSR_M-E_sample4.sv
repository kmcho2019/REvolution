module LFSR_Galois (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

    // Initialize the LFSR with a seed value
    initial begin
        out = 4'b1001;
    end

    // Sequential logic for updating the LFSR state
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize state to seed value on reset
            out <= 4'b1001;
        end else begin
            // Calculate new bit values using XOR gates
            out[3] <= out[2] ^ out[0];
            out[2] <= out[1] ^ out[0];
            out[1] <= out[0];
            out[0] <= out[3];
        end
    end

endmodule

// Testbench for verification
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
        $dumpfile("LFSR_Galois_testbench.vcd");
        $dumpvars(0, LFSR_Galois_testbench);
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
        $monitor("out = %b", out);
    end

endmodule