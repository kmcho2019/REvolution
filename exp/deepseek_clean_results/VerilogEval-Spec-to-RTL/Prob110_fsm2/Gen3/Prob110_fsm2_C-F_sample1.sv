module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding with localparam for clarity
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Input registers for change detection
    reg j_prev, k_prev;

    // Combined state transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= OFF;  // Async reset to OFF state
            j_prev <= 1'b0;
            k_prev <= 1'b0;
        end else begin
            // Only evaluate transitions if inputs changed
            if (j != j_prev || k != k_prev) begin
                case (out)
                    OFF: out <= j ? ON : OFF;  // Transition on j
                    ON:  out <= k ? OFF : ON;  // Transition on k
                endcase
            end
            j_prev <= j;
            k_prev <= k;
        end
    end

endmodule