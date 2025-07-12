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
        if (out == 4'b0000)
            out <= 4'b0001; // escape zero lock-up state
        else
            out <= {out[2:0], feedback};
    end
end

endmodule

module tb_LFSR;

reg clk = 0;          // clock must be reg for procedural toggling
reg rst = 1;          // reset must be reg for procedural assignment
wire [3:0] out;       // output from DUT is wire

// Instantiate DUT
LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generation: 10 time units period
always #5 clk = ~clk;

initial begin
    $display("Time\tclk rst out");
    $monitor("%0t\t%b   %b  %b", $time, clk, rst, out);

    #15 rst = 0;    // release reset after some cycles
    #100 $finish;   // finish simulation
end

endmodule