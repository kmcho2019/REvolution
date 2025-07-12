module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)

// Fixed width counter (8 bits supports division up to 510)
reg [7:0] cnt;
localparam CNT_MAX = (NUM_DIV/2) - 1;

// Parameter validation
generate
    if (NUM_DIV % 2 != 0) begin
        illegal_parameter_condition: assert(0) else
            $error("NUM_DIV must be an even number");
    end
    if (NUM_DIV > 510) begin
        illegal_parameter_range: assert(0) else
            $error("NUM_DIV must be <= 510");
    end
endgenerate

reg div_toggle;

// Clock division logic
assign clk_div = div_toggle;

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 0;
        div_toggle <= 0;
    end
    else begin
        if (cnt == CNT_MAX) begin
            cnt <= 0;
            div_toggle <= ~div_toggle;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule