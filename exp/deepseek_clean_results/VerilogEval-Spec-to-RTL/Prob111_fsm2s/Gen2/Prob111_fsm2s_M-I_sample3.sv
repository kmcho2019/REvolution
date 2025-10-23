module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Define states
    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Clock gating logic
    wire clk_en = reset || (state == OFF && j) || (state == ON && k);

    // State transition logic with clock gating
    always @(posedge clk) begin
        if (clk_en) begin
            if (reset) begin
                state <= OFF;
            end else begin
                case (state)
                    OFF: state <= j ? ON : OFF;
                    ON:  state <= k ? OFF : ON;
                endcase
            end
        end
    end

    // Output logic (Moore machine: output depends only on state)
    assign out = state;

endmodule