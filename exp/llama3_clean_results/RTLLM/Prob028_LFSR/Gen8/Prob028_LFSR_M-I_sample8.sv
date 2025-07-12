module LFSR(
    input           clk,
    input           rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset LFSR to all zeros on rising edge of clk when rst is high
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and insert new feedback value at LSB
    end
end

endmodule

// Example testbench to demonstrate correct instantiation and port connection
module LFSR_tb;
    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, LFSR_tb);
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #100 $finish;
    end
endmodule