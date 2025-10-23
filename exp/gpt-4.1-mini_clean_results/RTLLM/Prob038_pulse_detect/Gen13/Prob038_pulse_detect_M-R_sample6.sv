module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states
    typedef enum reg [1:0] {
        S_WAIT0 = 2'd0,   // waiting for data_in == 0
        S_WAIT1 = 2'd1,   // detected 0, waiting for data_in == 1
        S_WAIT0_END = 2'd2 // detected 0->1, waiting for final 0 to confirm pulse
    } state_t;

    reg [1:0] state, next_state;

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= S_WAIT0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            S_WAIT0: begin
                if (data_in == 1'b0)
                    next_state = S_WAIT1;
                else
                    next_state = S_WAIT0;
            end

            S_WAIT1: begin
                if (data_in == 1'b1)
                    next_state = S_WAIT0_END;
                else if (data_in == 1'b0)
                    next_state = S_WAIT1; // stay here until 1
                else
                    next_state = S_WAIT0;
            end

            S_WAIT0_END: begin
                if (data_in == 1'b0)
                    next_state = S_WAIT0; // pulse complete, go back to wait0
                else
                    next_state = S_WAIT0_END; // wait for final 0
            end

            default: next_state = S_WAIT0;
        endcase
    end

    // Output logic: data_out is asserted only when transitioning from S_WAIT0_END to S_WAIT0 (i.e., end of pulse)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 1'b0;
        end else begin
            data_out <= (state == S_WAIT0_END) && (next_state == S_WAIT0);
        end
    end

endmodule