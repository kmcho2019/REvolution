module DFF8_negclk_sync_reset_array (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    reg [7:0] q_reg_array;
    reg reset_applied;

    always @(negedge clk) begin
        if (reset) begin
            if (!reset_applied) begin
                q_reg_array <= 8'h34;       // Load reset value once on reset assertion
                reset_applied <= 1'b1;     // Mark that reset has been applied
            end else begin
                q_reg_array <= q_reg_array; // Hold stable to avoid toggling
            end
        end else begin
            q_reg_array <= d;              // Load data when not in reset
            reset_applied <= 1'b0;         // Clear reset applied flag
        end
    end

    assign q = q_reg_array;

endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);

    DFF8_negclk_sync_reset_array reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule