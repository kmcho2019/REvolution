module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Combinational logic: next state and output calculation
    always @(*) begin
        case (state)
            OFF: begin
                next_state = (j) ? ON : OFF;
                // Output depends only on state (Moore)
                // out is registered later, so no assignment here
            end
            ON: begin
                next_state = (k) ? OFF : ON;
            end
            default: begin
                next_state = OFF;
            end
        endcase
    end

    // Sequential logic: state update and output registration
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= next_state;  // Moore output registered with state
        end
    end

endmodule