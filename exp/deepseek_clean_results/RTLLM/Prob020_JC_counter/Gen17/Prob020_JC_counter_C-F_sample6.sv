module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
wire shift_enable = (Q != {64{Q[0]}}); // Enable when not in all-1s or all-0s state

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= Q_next;
    end
end

always @(*) begin
    if (shift_enable) begin
        Q_next = {~Q[0], Q[63:1]};
    end else begin
        Q_next = Q; // Hold state when fully saturated
    end
end

// Synthesis attributes for optimization
// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q is "yes";

endmodule