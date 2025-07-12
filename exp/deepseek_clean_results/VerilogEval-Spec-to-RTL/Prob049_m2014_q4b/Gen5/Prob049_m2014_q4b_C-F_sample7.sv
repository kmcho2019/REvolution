module TopModule #(
    parameter RESET_VALUE = 1'b0,     // Configurable reset value
    parameter ACTIVE_LOW_RESET = 1,   // 1=active low, 0=active high
    parameter SYNC_RESET = 0          // 0=async (default), 1=sync
)(
    input  clk,
    input  ar,    // Reset (polarity configurable)
    input  d,
    output q
);

reg q_reg;
wire reset_condition = ACTIVE_LOW_RESET ? ~ar : ar;

assign q = q_reg;

generate
    if (SYNC_RESET) begin: sync_reset
        always @(posedge clk) begin
            if (reset_condition)
                q_reg <= RESET_VALUE;
            else
                q_reg <= d;
        end
    end else begin: async_reset
        always @(posedge clk or posedge reset_condition) begin
            if (reset_condition)
                q_reg <= RESET_VALUE;
            else
                q_reg <= d;
        end
    end
endgenerate

// synthesis attribute async_set_reset "reset_condition"
// synthesis attribute sync_set_reset "none"
// synthesis attribute clock_gating_hint "q_reg"

endmodule