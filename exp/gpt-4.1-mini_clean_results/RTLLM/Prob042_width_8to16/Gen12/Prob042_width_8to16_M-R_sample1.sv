module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {
        IDLE        = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] first_byte;
    reg       output_ready;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and data handling
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
            end
        endcase
    end

    // Data and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte   <= 8'd0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
            output_ready <= 1'b0;
        end else begin
            valid_out <= output_ready;
            output_ready <= 1'b0; // default no output

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        // Store first byte and wait for second
                        first_byte <= data_in;
                        output_ready <= 1'b0;
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate and output on next cycle
                        data_out <= {first_byte, data_in};
                        output_ready <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule