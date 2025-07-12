module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;  // Helps with timing closure

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end else begin
        // Johnson counter operation:
        // When LSB=0: right shift with MSB=1 (counting up)
        // When LSB=1: right shift with MSB=0 (counting down)
        // Note: For power optimization, consider clock gating when counter is stable
        Q <= Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
    end
end

endmodule