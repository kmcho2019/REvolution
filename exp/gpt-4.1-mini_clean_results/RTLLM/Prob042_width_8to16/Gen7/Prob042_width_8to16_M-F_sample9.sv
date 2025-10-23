module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, state_next;

    reg [7:0]  data_lock;       // stores first received byte
    reg [15:0] pending_output;  // output data to be valid next cycle
    reg        pending_valid;   // indicates pending output validity

    // Next state logic (combinational)
    always @(*) begin
        state_next = state;
        case(state)
            IDLE: begin
                if (valid_in)
                    state_next = WAIT_SECOND;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    state_next = IDLE;
                // else remain in WAIT_SECOND waiting for second data
            end
        endcase
    end

    // Sequential logic: state update, data_lock, pending_output, pending_valid, and outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            data_lock      <= 8'd0;
            pending_output <= 16'd0;
            pending_valid  <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            state <= state_next;

            // Default keep output stable if no new pending_valid
            valid_out <= pending_valid;
            data_out  <= pending_output;

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;    // latch first byte
                        // No output generation
                        pending_valid <= 1'b0;   // ensure no stale pending_valid
                    end else begin
                        // No input, no output
                        pending_valid <= 1'b0;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // On second valid input, prepare output next cycle
                        pending_output <= {data_lock, data_in};
                        pending_valid  <= 1'b1;
                        // Do not update data_lock here
                    end else begin
                        // Wait for second input, clear pending_valid to avoid repeated output
                        pending_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule