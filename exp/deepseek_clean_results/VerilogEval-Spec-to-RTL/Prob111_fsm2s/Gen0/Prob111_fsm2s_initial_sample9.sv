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

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == ON);

endmodule