module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // On every positive edge of clk, sample and latch input d
    always @(posedge clk) begin
        q <= d;
    end

    // Optional: initialize q to zero for simulation clarity
    // synthesis translate_off
    initial begin
        q = 8'b0;
    end
    // synthesis translate_on

endmodule