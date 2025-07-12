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
    wire state_change;
    assign state_change = (state == OFF) ? j :  // OFF and j=1
                         (state == ON) ? k :   // ON and k=1
                         1'b0;                 // default (shouldn't occur)

    wire gated_clk;
    assign gated_clk = clk & (reset | state_change);

    // State transition logic
    always @(posedge gated_clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= ON;
                ON:  state <= OFF;
            endcase
        end
    end

    // Output logic (Moore machine: output depends only on state)
    assign out = state;

endmodule