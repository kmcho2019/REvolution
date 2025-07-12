module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // State encoding
    typedef enum logic [2:0] {
        S0,
        S1,
        S2,
        S3,
        S_DONE
    } state_t;

    state_t current_state;

    assign shift_ena = (current_state != S_DONE);

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            case (current_state)
                S0: current_state <= S1;
                S1: current_state <= S2;
                S2: current_state <= S3;
                S3: current_state <= S_DONE;
                S_DONE: current_state <= S_DONE;  // Stay here forever
                default: current_state <= S_DONE;  // Fault recovery
            endcase
        end
    end

endmodule