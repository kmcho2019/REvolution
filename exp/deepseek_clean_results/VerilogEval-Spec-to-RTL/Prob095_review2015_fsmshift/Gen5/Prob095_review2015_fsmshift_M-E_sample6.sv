module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    typedef enum logic [2:0] {
        S0,     // First active cycle
        S1,     // Second active cycle
        S2,     // Third active cycle
        S3,     // Fourth active cycle
        S_DONE  // Terminal state
    } state_t;

    state_t current_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            case (current_state)
                S0: current_state <= S1;
                S1: current_state <= S2;
                S2: current_state <= S3;
                S3: current_state <= S_DONE;
                S_DONE: current_state <= S_DONE;
                default: current_state <= S_DONE;
            endcase
        end
    end

    assign shift_ena = (current_state != S_DONE);

endmodule