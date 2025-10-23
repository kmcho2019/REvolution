module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;  // Help with timing closure
// synthesis attribute shreg_extract of Q is "no";  // Prevent shift register optimization

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset
    end else begin
        /* Johnson counter operation:
         * Right shift with MSB = ~LSB
         * Equivalent to: Q <= Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
         * but more compact and equally efficient
         */
        Q <= {~Q[0], Q[63:1]};
        
        // For power optimization: Could add clock gating when Q is all 1s or all 0s
        // if (Q == 64'hFFFFFFFFFFFFFFFF || Q == 64'h0) disable counter;
    end
end

endmodule