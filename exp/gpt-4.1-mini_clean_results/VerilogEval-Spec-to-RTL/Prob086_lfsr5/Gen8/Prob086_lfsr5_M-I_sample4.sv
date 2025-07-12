module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // Shift right by 1, inserting feedback XORed at taps 5 and 3 (bits 4 and 2)
        q <= { (q[4] ^ feedback),          // bit 4 with feedback XOR
               q[4],                      // bit 3 (q[3]) shifts in from bit 4
               (q[2] ^ feedback),         // bit 2 with feedback XOR
               q[2],                      // bit 1 shifts in from bit 2
               q[1] };                   // bit 0 shifts in from bit 1
    end
end

endmodule