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

    // Combined state transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= OFF;  // Async reset to OFF state (out=0)
        end else begin
            case (out)
                OFF: out <= j ? ON : OFF;  // OFF transitions on j
                ON:  out <= k ? OFF : ON;  // ON transitions on k
            endcase
        end
    end

endmodule