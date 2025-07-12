module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding as parameters for synthesis friendliness
    localparam S0 = 1'b0; // copy input bits until first '1'
    localparam S1 = 1'b1; // invert input bits after first '1'

    reg state;

    // Combined state update and input sampling in one always block
    // Asynchronous reset on state to S0, positive-edge triggered
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
        end else begin
            // FSM next-state logic depends on state and current input x
            case (state)
                S0: state <= (x) ? S1 : S0;
                S1: state <= S1;
                default: state <= S0;
            endcase
        end
    end

    // Moore output: combinational from state and current input x
    assign z = (state == S0) ? x : ~x;

endmodule