module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // More synthesis-friendly state encoding names
    localparam S_OFF = 1'b0;
    localparam S_ON  = 1'b1;

    reg state;

    // Sequential state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_OFF;
        end else begin
            case (state)
                S_OFF: state <= j ? S_ON : S_OFF;
                S_ON:  state <= k ? S_OFF : S_ON;
            endcase
        end
    end

    // Direct state-to-output assignment (Moore output)
    assign out = state;  // No comparison needed since state directly represents output

endmodule