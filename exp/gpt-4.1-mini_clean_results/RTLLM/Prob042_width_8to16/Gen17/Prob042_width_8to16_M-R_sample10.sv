module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT      = 2'b10
    } state_t;

    state_t current_state, next_state;

    reg [7:0] data_lock;        // store first 8-bit data
    reg [15:0] output_data;     // stage output data

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_lock    <= 8'd0;
            output_data  <= 16'd0;
            valid_out    <= 1'b0;
            data_out     <= 16'd0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        output_data <= {data_lock, data_in};
                    end
                end

                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out  <= output_data;
                end

                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = OUTPUT;
            end

            OUTPUT: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule