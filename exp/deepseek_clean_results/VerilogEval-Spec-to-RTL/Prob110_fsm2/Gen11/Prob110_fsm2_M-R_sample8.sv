module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // Explicit state encoding
    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end

    // Output logic - pure combinational
    assign out = state;

endmodule