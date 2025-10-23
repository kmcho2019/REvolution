module LFSR (
    input           clk,        // Clock signal
    input           rst,        // Active high reset signal
    output reg [3:0] out        // 4-bit output representing the current state of the LFSR
);

    // Sequential logic for updating the LFSR state
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize state to zero on reset
            out <= 4'b0000;
        end else begin
            // Calculate new bit values using the specified feedback mechanism
            reg [3:0] next_out;
            reg fb;
            // Calculate feedback
            fb = ~(out[3] ^ out[2]);
            // Shift bits and insert feedback at LSB
            next_out[3] = out[2];
            next_out[2] = out[1];
            next_out[1] = out[0];
            next_out[0] = fb;
            out <= next_out;
        end
    end

endmodule

// Testbench for verification
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
        $dumpfile("LFSR_testbench.vcd");
        $dumpvars(0, LFSR_testbench);
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