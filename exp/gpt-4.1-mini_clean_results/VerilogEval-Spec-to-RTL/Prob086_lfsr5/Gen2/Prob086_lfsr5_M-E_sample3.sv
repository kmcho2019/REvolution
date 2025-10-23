module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // Reset to 1 on active high synchronous reset
        end else begin
            reg [4:0] next_state;
            wire feedback = q[0];
            
            // Shift right by one with taps at bits 5 and 3 (q[4] and q[2])
            // For tapped bits, XOR with feedback
            next_state[0] = q[1];
            next_state[1] = q[2];
            next_state[2] = q[3] ^ feedback; // tap at bit 3
            next_state[3] = q[4];
            next_state[4] = q[4] ^ feedback; // tap at bit 5
            
            q <= next_state;
        end
    end

endmodule