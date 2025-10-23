module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot encoded states (6 states)
    localparam S0 = 6'b000001; // initial state, no bits matched
    localparam S1 = 6'b000010; // matched '1'
    localparam S2 = 6'b000100; // matched "11"
    localparam S3 = 6'b001000; // matched "110"
    localparam S4 = 6'b010000; // matched "1101" detected state
    localparam S5 = 6'b100000; // final sticky detected state to hold output forever

    reg [5:0] state, next_state;

    // Synchronous state update with active-high synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic for sequence detection with one-hot states
    always @(*) begin
        // default next_state is to stay in current state
        next_state = state;

        case (state)
            S0: begin
                if (data)      next_state = S1;
                else           next_state = S0;
            end
            S1: begin
                if (data)      next_state = S2;
                else           next_state = S0;
            end
            S2: begin
                if (data)      next_state = S2; // stay on S2 if data=1 (to handle overlapping)
                else           next_state = S3;
            end
            S3: begin
                if (data)      next_state = S4;
                else           next_state = S0;
            end
            S4: begin
                // move into sticky detected state on next cycle
                next_state = S5;
            end
            S5: begin
                // hold detected state forever
                next_state = S5;
            end
            default: next_state = S0;
        endcase
    end

    // start_shifting asserted high when in sticky detected state S5
    assign start_shifting = (state == S5);

endmodule