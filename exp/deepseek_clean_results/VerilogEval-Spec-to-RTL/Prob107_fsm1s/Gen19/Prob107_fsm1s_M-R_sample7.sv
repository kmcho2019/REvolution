module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding using localparams
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;

    reg state;  // Current state register

    // State transition and register update
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            // Embedded next state logic
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
        end
    end

    // Output assignment - explicit based on current state
    assign out = (state == STATE_B);

endmodule