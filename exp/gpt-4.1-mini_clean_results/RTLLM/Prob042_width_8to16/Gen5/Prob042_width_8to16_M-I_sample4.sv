module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE        = 2'd0,
        WAIT_SECOND = 2'd1,
        OUTPUT      = 2'd2
    } state_t;

    state_t current_state, next_state;

    reg [7:0] data_lock;

    // FSM state register and outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_lock     <= 8'd0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            current_state <= next_state;

            // Default valid_out low; asserted only in OUTPUT state
            if (next_state == OUTPUT) begin
                // Output registered here: concatenate stored and new data_in
                data_out  <= {data_lock, data_in};
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end

            // Store first byte when transitioning from IDLE to WAIT_SECOND
            if (current_state == IDLE && valid_in) begin
                data_lock <= data_in;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = OUTPUT;
                else
                    next_state = WAIT_SECOND;
            end
            OUTPUT: begin
                // After outputting valid data, return to IDLE waiting for next first byte
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule