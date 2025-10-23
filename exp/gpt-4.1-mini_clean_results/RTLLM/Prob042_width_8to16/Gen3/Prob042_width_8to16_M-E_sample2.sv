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
        IDLE = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] first_data;       // Holds first 8-bit input data
    reg [15:0] output_reg;      // Holds output data before assigned to data_out

    // FSM Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            first_data  <= 8'd0;
            output_reg  <= 16'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    data_out  <= data_out;  // hold last value unless updated in OUTPUT
                    if (valid_in) begin
                        first_data <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    valid_out <= 1'b0;
                    data_out  <= data_out;  // hold
                    if (valid_in) begin
                        output_reg <= {first_data, data_in};
                    end
                end

                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out  <= output_reg;
                end

                default: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                    first_data <= 8'd0;
                end
            endcase
        end
    end

    // FSM Combinational next state logic
    always @(*) begin
        next_state = state; // default hold state

        case (state)
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