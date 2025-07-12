module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

wire c0, c1, c2;  // Carry signals for bitwise increment

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else begin
        // bit 0 toggles every cycle
        q[0] <= ~q[0];
        c0 <= q[0];  // carry out from bit 0 when incrementing
        // bit 1 toggles when bit 0 is 1 before toggling (carry in)
        q[1] <= q[1] ^ c0;
        c1 <= q[1] & c0;
        // bit 2 toggles when both bit 0 and bit 1 are 1 before toggling
        q[2] <= q[2] ^ c1;
        c2 <= q[2] & c1;
        // bit 3 toggles when bits 0-2 are all 1 before toggling
        q[3] <= q[3] ^ c2;
    end
end

endmodule