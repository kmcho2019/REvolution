module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE         = 2'b00,
        WAIT_SECOND  = 2'b01,
        OUTPUT_WAIT  = 2'b10,
        OUTPUT       = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;    // Store first 8-bit input
    reg [7:0] data_second;  // Store second 8-bit input

    // Sequential state, data, and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'd0;
            data_second<= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                    if (valid_in)
                        data_lock <= data_in;
                end

                WAIT_SECOND: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                    if (valid_in)
                        data_second <= data_in;
                end

                OUTPUT_WAIT: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                    // no data capture here, just wait
                end

                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out  <= {data_lock, data_second};
                end

                default: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                end
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = OUTPUT_WAIT;
                else
                    next_state = WAIT_SECOND;
            end

            OUTPUT_WAIT: begin
                next_state = OUTPUT;
            end

            OUTPUT: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule