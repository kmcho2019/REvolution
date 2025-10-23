// 4-bit LFSR module
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            out <= {out[2:0], feedback};
        end
    end

endmodule

// Testbench for the LFSR module
module tb_LFSR;

    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR module
    LFSR uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation: 10 time units period
    initial clk_tb = 0;
    always #5 clk_tb = ~clk_tb;

    // Test stimulus
    initial begin
        // Initialize reset
        rst_tb = 1;
        #15;          // Hold reset high for some cycles
        rst_tb = 0;   // Release reset

        // Let LFSR run for some cycles
        #100;

        // Finish simulation
        $finish;
    end

    // Optional: display the LFSR output at every clock edge for debug
    initial begin
        $monitor("At time %0t: rst=%b, LFSR out=%b", $time, rst_tb, out_tb);
    end

endmodule