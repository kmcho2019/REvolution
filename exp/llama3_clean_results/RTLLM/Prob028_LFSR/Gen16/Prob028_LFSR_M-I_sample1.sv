// Improved LFSR module with explicit reset handling
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Update the register on the rising edge of the clock
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift left and insert feedback at LSB
    end
end

endmodule

// Example testbench for the LFSR module
module LFSR_testbench;
    reg clk, rst;
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
        #10 rst = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        #100 $finish;
    end
endmodule