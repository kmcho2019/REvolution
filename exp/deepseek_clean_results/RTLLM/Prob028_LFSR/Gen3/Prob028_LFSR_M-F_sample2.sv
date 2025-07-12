module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

assign feedback = ~(out[3] ^ out[2]);  // XOR bits 3 and 2, then invert

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Initialize to zero on reset
    end
    else begin
        out <= {out[2:0], feedback};  // Left shift with feedback at LSB
    end
end

endmodule

// Testbench
module LFSR_tb;
    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR
    LFSR dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    // Stimulus
    initial begin
        rst_tb = 1;  // Assert reset
        #10;
        rst_tb = 0;  // Deassert reset
        #100;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time = %0t, out = %b", $time, out_tb);
    end

endmodule