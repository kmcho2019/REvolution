module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg x_prev, x_prev_prev;  // Stores previous two x values
    reg x_stable;             // Indicates if x has been stable
    wire clk_en;              // Clock enable signal

    // Clock gating logic - only enable clock when input changes
    assign clk_en = (x != x_prev) || !aresetn;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_prev <= 1'b0;
            x_prev_prev <= 1'b0;
            z <= 1'b0;
            x_stable <= 1'b0;
        end else if (clk_en) begin
            x_prev_prev <= x_prev;
            x_prev <= x;
            z <= x_prev_prev & ~x_prev & x;
            x_stable <= 1'b0;
        end else begin
            x_stable <= 1'b1;
        end
    end

endmodule