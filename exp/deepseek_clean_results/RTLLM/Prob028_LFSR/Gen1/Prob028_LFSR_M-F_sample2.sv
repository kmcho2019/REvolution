module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Reset state
    end else begin
        // Shift left and insert inverted XOR of bits 3 and 2 at LSB
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

module LFSR_tb;
    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        rst = 1;  // Assert reset
        #10;
        rst = 0;  // Deassert reset
        #100;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time = %0t, out = %b", $time, out);
    end
endmodule