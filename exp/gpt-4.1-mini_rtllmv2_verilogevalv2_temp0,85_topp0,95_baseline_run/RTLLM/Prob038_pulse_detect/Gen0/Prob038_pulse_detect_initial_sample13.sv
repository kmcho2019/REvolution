module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'd0, // waiting for first 0
        S1 = 2'd1, // detected 0, waiting for 1
        S2 = 2'd2  // detected 0->1, waiting for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is set only in S2 when next state is S0 and data_in==0
            // Otherwise 0
            if (state == S2 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (data_in == 1'b0)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (data_in == 1'b1)
                    next_state = S2;
                else if (data_in == 1'b0)
                    next_state = S1; // stay waiting for 1
                else
                    next_state = S0;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S0; // pulse complete
                else if (data_in == 1'b1)
                    next_state = S2; // stay waiting for 0
                else
                    next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

endmodule