module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state; // internal state representing (q+3) mod 7

// Compute q from state as (state + 4) mod 7
wire [3:0] q_next_mod7 = state + 4; // 4-bit to handle carry
wire [2:0] q_next = (q_next_mod7 >= 7) ? (q_next_mod7 - 7) : q_next_mod7[2:0];

always @(posedge clk) begin
    if (a) begin
        state <= 3'd0; // corresponds to q=4
    end else begin
        // increment modulo 7
        if (state == 3'd6)
            state <= 3'd0;
        else
            state <= state + 3'd1;
    end
    q <= q_next;
end

endmodule