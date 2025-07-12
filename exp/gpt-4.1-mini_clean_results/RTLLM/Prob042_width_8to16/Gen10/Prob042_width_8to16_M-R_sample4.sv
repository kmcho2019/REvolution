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
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;
    reg valid_out_next;
    reg [15:0] data_out_next;

    // FSM next state logic and data_lock update
    always @(*) begin
        next_state     = state;
        valid_out_next = 1'b0;
        data_out_next  = 16'd0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // On second valid input, prepare output in next cycle
                    valid_out_next = 1'b1;
                    data_out_next  = {data_lock, data_in};
                    next_state     = IDLE;
                end
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'd0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            state <= next_state;

            if (state == IDLE && valid_in) begin
                // Store first input data when in IDLE
                data_lock <= data_in;
            end

            // Update outputs; valid_out asserted one cycle after second input
            valid_out <= valid_out_next;
            data_out  <= data_out_next;
        end
    end

endmodule