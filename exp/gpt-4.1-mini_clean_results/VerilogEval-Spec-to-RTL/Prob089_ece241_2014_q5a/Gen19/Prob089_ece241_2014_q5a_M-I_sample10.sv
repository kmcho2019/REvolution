module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding using localparam for minimal synthesis overhead
    localparam S0 = 1'b0; // Copy input bits until first '1' encountered
    localparam S1 = 1'b1; // Invert bits after first '1'

    reg state;     // 1-bit FSM state register
    reg x_sampled; // Sampled input bit, combined in same always block

    // Combined asynchronous reset and sequential logic for input sampling and state
    // This reduces flip-flops and synchronizes input sampling with state updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= S0;
            x_sampled <= 1'b0;
        end else begin
            x_sampled <= x;
            case(state)
                S0: state <= (x_sampled) ? S1 : S0;
                S1: state <= S1;
            endcase
        end
    end

    // Output combinational logic: Moore FSM output based on current state and sampled input
    assign z = (state == S0) ? x_sampled : ~x_sampled;

endmodule