module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;           // Store first byte
    reg [15:0] output_buffer;      // Buffer output data before valid_out assert
    reg        valid_buffer;       // Buffer valid_out signal for one cycle delay

    // State and data_lock update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            output_buffer <= 16'd0;
            valid_buffer  <= 1'b0;
        end else begin
            state <= next_state;
            valid_buffer <= 1'b0; // Default no valid output each cycle unless set below

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;     // Store first byte
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        output_buffer <= {data_lock, data_in};  // Concatenate stored and current byte
                        valid_buffer  <= 1'b1;                   // Prepare valid output next cycle
                    end
                end
            endcase
        end
    end

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
                    next_state = IDLE; // After second byte, go back to IDLE
                else
                    next_state = WAIT_SECOND;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output registers: register valid_out and data_out one cycle after output_buffer is updated
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 16'd0;
        end else begin
            valid_out <= valid_buffer;
            if (valid_buffer)
                data_out <= output_buffer;
        end
    end

endmodule