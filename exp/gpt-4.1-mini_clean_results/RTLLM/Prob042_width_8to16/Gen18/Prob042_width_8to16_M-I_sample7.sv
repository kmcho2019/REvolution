module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;
    reg [7:0] data_lock;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
                else
                    next_state = WAIT_SECOND;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, data locking, output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            data_lock <= 8'd0;
            data_out  <= 16'd0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0; // No output valid in IDLE state
                    if (valid_in) begin
                        data_lock <= data_in;  // Store first byte
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // On second valid_in, output concatenation next cycle
                        data_out  <= {data_lock, data_in};
                        valid_out <= 1'b1;
                    end else begin
                        valid_out <= 1'b0; // Hold no output if no second data yet
                    end
                end
            endcase
        end
    end

endmodule