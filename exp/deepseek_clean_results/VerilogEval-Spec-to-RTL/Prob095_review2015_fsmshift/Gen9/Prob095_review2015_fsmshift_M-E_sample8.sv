module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // State encoding - one-hot for clarity
    typedef enum logic [3:0] {
        S_RESET = 4'b0001,
        S_CYC1  = 4'b0010,
        S_CYC2  = 4'b0100,
        S_CYC3  = 4'b1000,
        S_DONE  = 4'b0000
    } state_t;

    state_t current_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_RESET;
        end else begin
            case (current_state)
                S_RESET: current_state <= S_CYC1;
                S_CYC1:  current_state <= S_CYC2;
                S_CYC2:  current_state <= S_CYC3;
                S_CYC3:  current_state <= S_DONE;
                S_DONE:  current_state <= S_DONE;
                default: current_state <= S_DONE;
            endcase
        end
    end

    assign shift_ena = (current_state != S_DONE);

endmodule