module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg enable_counter;
reg Q0_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        enable_counter <= 1'b1;
        Q0_reg <= 1'b0;
    end else begin
        Q0_reg <= Q[0];  // Register LSB to reduce switching
        
        // Clock gating logic - disable when in extreme states
        enable_counter <= !((&Q) || (|Q == 0));
        
        if (enable_counter) begin
            // Optimized shift operation
            Q <= {~Q0_reg, Q[63:1]};
        end
    end
end

endmodule