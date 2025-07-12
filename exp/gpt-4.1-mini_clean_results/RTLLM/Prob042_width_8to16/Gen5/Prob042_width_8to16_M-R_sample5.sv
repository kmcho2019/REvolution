module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {WAIT_FIRST = 1'b0, WAIT_SECOND = 1'b1} state_t;
    state_t state, next_state;

    reg [7:0] data_lock;      // store first 8-bit input
    reg [15:0] data_out_next;
    reg valid_out_next;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= WAIT_FIRST;
            data_lock   <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state     <= next_state;
            data_lock <= (state == WAIT_FIRST && valid_in) ? data_in : data_lock;
            data_out  <= data_out_next;
            valid_out <= valid_out_next;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default values to hold outputs
        next_state     = state;
        data_out_next  = 16'd0;
        valid_out_next = 1'b0;

        case (state)
            WAIT_FIRST: begin
                valid_out_next = 1'b0;
                data_out_next  = 16'd0;
                if (valid_in) begin
                    // Store first input and wait for second
                    next_state = WAIT_SECOND;
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // Second input arrived: concatenate and output next cycle
                    data_out_next  = {data_lock, data_in};
                    valid_out_next = 1'b1;
                    next_state     = WAIT_FIRST;
                end else begin
                    // Waiting for second input, no output
                    valid_out_next = 1'b0;
                    data_out_next  = 16'd0;
                    next_state     = WAIT_SECOND;
                end
            end
        endcase
    end

endmodule