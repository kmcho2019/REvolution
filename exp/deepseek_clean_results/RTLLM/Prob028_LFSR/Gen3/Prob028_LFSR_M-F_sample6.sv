module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

// Feedback calculation: XOR of MSB and second MSB, then inverted
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Synchronous reset to all zeros
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule

// Corrected testbench
module LFSR_tb;
    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR with proper connections
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
        rst_tb = 1;
        #10 rst_tb = 0;
        #100 $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time = %0t, out = %4b", $time, out_tb);
    end
endmodule