module TopModule(
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    // Each bit is implemented as an independent negative-edge triggered DFF with synchronous reset
    // Reset value for q is 8'h34 = 8'b0011_0100

    always @(negedge clk) begin
        if (reset) begin
            q[0] <= 1'b0; // bit0 of 0x34
            q[1] <= 1'b0; // bit1 of 0x34
            q[2] <= 1'b1; // bit2 of 0x34
            q[3] <= 1'b0; // bit3 of 0x34
            q[4] <= 1'b1; // bit4 of 0x34
            q[5] <= 1'b1; // bit5 of 0x34
            q[6] <= 0'b0; // bit6 of 0x34
            q[7] <= 1'b0; // bit7 of 0x34
        end else begin
            q <= d;
        end
    end
endmodule