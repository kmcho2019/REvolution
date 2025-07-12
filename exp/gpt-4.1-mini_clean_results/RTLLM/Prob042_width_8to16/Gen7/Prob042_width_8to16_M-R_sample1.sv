module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        HOLD = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;    // stores first valid input
    reg [7:0] data_second;  // stores second valid input

    reg output_valid;       // signal to indicate output should be valid next cycle

    // Sequential logic: state and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            data_second <= 8'd0;
            output_valid<= 1'b0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            state <= next_state;

            // By default clear valid_out and output_valid unless set below
            valid_out <= 1'b0;

            // Output valid and data generation
            if (output_valid) begin
                valid_out <= 1'b1;
                data_out  <= {data_lock, data_second};
            end else begin
                data_out <= data_out; // hold previous output
            end

            // Update data_lock and data_second depending on state and valid_in
            case(state)
                IDLE: begin
                    output_valid <= 1'b0;
                    if (valid_in) begin
                        data_lock <= data_in;
                    end else begin
                        data_lock <= data_lock; // hold
                    end
                    data_second <= 8'd0;
                end
                HOLD: begin
                    if (valid_in) begin
                        data_second <= data_in;
                        output_valid <= 1'b1; // output next cycle
                    end else begin
                        data_second <= data_second; // hold if no valid input
                        output_valid <= 1'b0;
                    end
                end
                default: begin
                    data_lock <= 8'd0;
                    data_second <= 8'd0;
                    output_valid <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = HOLD;
                else
                    next_state = IDLE;
            end
            HOLD: begin
                if (valid_in)
                    next_state = IDLE;  // after second input, back to IDLE
                else
                    next_state = HOLD;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule