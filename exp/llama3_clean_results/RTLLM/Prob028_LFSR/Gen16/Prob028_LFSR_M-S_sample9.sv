module LFSR(
    input clk,       // Clock signal
    input rst,       // Active high reset signal
    output reg [3:0] out // 4-bit output
);

wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk or posedge rst) begin
    if (rst) out <= 4'b0;
    else out <= {out[2:0], feedback};
end

endmodule

module LFSR_tb;
    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR lfsr_instance(
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        $dumpvars();
        #100;
        $finish();
    end

    always #5 clk = ~clk;
endmodule