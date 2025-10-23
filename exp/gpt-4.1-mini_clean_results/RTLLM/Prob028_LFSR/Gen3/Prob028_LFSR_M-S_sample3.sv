module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Simple testbench to observe output
module LFSR_tb;

    reg clk = 0;
    reg rst = 0;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock: toggle every 5 time units (10 units period)
    always #5 clk = ~clk;

    initial begin
        rst = 1;           // Apply reset
        #10;
        rst = 0;           // Release reset

        // Run simulation for several clock cycles
        #100;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst, out);
    end

endmodule