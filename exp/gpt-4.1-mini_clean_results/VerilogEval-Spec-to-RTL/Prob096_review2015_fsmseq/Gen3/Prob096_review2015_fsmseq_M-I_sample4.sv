module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding
    localparam S0     = 3'b000;
    localparam S1     = 3'b001;
    localparam S11    = 3'b010;
    localparam S110   = 3'b011;
    localparam S_DONE = 3'b100;

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S0;
            end
            S11: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S110;
            end
            S110: begin
                if (data)
                    next_state = S_DONE; // sequence 1101 detected
                else
                    next_state = S0;
            end
            S_DONE: begin
                next_state = S_DONE; // stay latched forever until reset
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and output latch
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            start_shifting <= (next_state == S_DONE) ? 1'b1 : start_shifting;
        end
    end

endmodule