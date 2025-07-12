module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    reg [6:0] state;
    parameter [6:0] 
        state0 = 7'b0000001,
        state1 = 7'b0000010,
        state2 = 7'b0000100,
        state3 = 7'b0001000,
        state4 = 7'b0010000,
        state5 = 7'b0100000,
        state6 = 7'b1000000;

    always @(posedge clk) begin
        if (reset) begin
            state <= state0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            case (1'b1) // synthesis parallel_case
                state[0]: state <= in ? state1 : state0;
                state[1]: state <= in ? state2 : state0;
                state[2]: state <= in ? state3 : state0;
                state[3]: state <= in ? state4 : state0;
                state[4]: state <= in ? state5 : state0;
                state[5]: begin
                    if (in) state <= state6;
                    else begin
                        state <= state0;
                        disc <= 1;
                    end
                end
                state[6]: begin
                    if (in) begin
                        state <= state6;
                        err <= 1;
                    end else begin
                        state <= state0;
                        flag <= 1;
                    end
                end
                default: state <= state0;
            endcase
        end
    end

endmodule