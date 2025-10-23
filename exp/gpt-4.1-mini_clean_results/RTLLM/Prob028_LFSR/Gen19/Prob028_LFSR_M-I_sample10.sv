module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst)
        out <= 4'b0000; // reset as problem states
    else begin
        // Shift left and insert feedback at LSB
        // If out is zero (locked state), force LSB to 1 to escape lock-up
        if (out == 4'b0000)
            out <= 4'b0001;
        else
            out <= {out[2:0], feedback};
    end
end

endmodule

module tb_LFSR;

reg clk = 0;
reg rst = 1;
wire [3:0] out;

LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

always #5 clk = ~clk;

initial begin
    $display("Time\tclk rst out");
    $monitor("%0t\t%b   %b  %b", $time, clk, rst, out);
    
    #10 rst = 0;     // release reset
    #100 $finish;    // end simulation
end

endmodule