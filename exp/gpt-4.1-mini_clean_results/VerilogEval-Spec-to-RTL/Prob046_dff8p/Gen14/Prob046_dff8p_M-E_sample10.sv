module DFF8_negclk_sync_reset_array (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    // Declare an array of 1-bit registers for each flip-flop
    reg [7:0] q_reg_array;

    // On negative edge of clk, synchronously load reset value or input d
    always @(negedge clk) begin
        if (reset) begin
            q_reg_array <= 8'h34;  // Synchronous active-high reset value
        end else begin
            q_reg_array <= d;
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