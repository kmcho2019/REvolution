// LFSR module as originally specified
module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], ~(out[3] ^ out[2])};
    end

endmodule

// Testbench for LFSR with correct signal declarations and connections
module tb_LFSR;

    reg        clk_tb;
    reg        rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR module with matching port widths
    LFSR uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Generate clock with 10 time units period
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    // Test sequence: apply reset and run for several cycles
    initial begin
        rst_tb = 1;
        #20;
        rst_tb = 0;
        // Run the LFSR for 50 clock cycles
        repeat (50) @(posedge clk_tb);
        $finish;
    end

    // Optional: monitor outputs for debugging
    initial begin
        $monitor("Time: %0t | Reset: %b | LFSR out: %b", $time, rst_tb, out_tb);
    end

endmodule