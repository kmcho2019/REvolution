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

    reg [7:0]  data_lock;        // stores first received byte
    reg [15:0] output_latch;     // holds concatenated output data (ready to be output next cycle)
    reg        pending_valid;    // flag indicating output_latch has valid data to output next cycle

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    state_next = WAIT_SECOND;
                else
                    state_next = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    state_next = IDLE;
                else
                    state_next = WAIT_SECOND;
            end
            default: state_next = IDLE;
        endcase
    end

    // Sequential logic: state update, registers, and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            data_lock     <= 8'd0;
            output_latch  <= 16'd0;
            pending_valid <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            state <= state_next;

            // Clear valid_out by default; assert only when output is valid
            valid_out <= 1'b0;

            case(state)
                IDLE: begin
                    // No pending output in IDLE
                    // Store first valid data if any
                    if (valid_in) begin
                        data_lock <= data_in;
                    end

                    // pending_valid should remain unchanged here; outputs are handled below
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // On second valid input:
                        // - Capture concatenated data into output_latch
                        // - Set pending_valid so output will happen next cycle
                        output_latch  <= {data_lock, data_in};
                        pending_valid <= 1'b1;
                    end
                    // If no valid input, keep waiting
                end
            endcase

            // Output stage: one cycle delayed from pending_valid
            // If pending_valid was set in previous cycle, assert valid_out and output data_out
            if (pending_valid) begin
                data_out  <= output_latch;
                valid_out <= 1'b1;
                pending_valid <= 1'b0; // clear after output asserted
            end
        end
    end

endmodule