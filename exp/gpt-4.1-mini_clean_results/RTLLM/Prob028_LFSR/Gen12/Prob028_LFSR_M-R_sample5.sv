module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg [3:0]  out
);
    wire feedback;
    reg [3:0] next_out;

    assign feedback = ~(out[3] ^ out[2]);
    assign next_out = {out[2:0], feedback};

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0;
        else
            out <= next_out;
    end
endmodule

module tb_LFSR;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    LFSR dut (.clk(clk), .rst(rst), .out(out));

    always #5 clk = ~clk;

    initial begin
        #10 rst = 0;    // release reset after one clock cycle
        #100 $finish;
    end

    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%0t\t%b\t%b\t%04b", $time, clk, rst, out);
    end
endmodule