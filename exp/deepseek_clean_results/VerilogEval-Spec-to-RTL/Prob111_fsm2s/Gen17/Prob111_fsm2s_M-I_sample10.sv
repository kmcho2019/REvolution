module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding with named parameters
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg j_prev, k_prev;
    wire clk_en;

    // Clock gating when inputs change
    assign clk_en = (j != j_prev) || (k != k_prev) || reset;

    always @(posedge clk) begin
        j_prev <= j;
        k_prev <= k;
    end

    always @(posedge clk) begin
        if (!clk_en) begin
            // No change in inputs, hold state
        end
        else if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end
        else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
            out <= state;
        end
    end

endmodule