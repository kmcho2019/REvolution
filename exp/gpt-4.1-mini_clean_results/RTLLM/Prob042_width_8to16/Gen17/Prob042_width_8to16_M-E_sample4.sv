module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT = 1'b1
    } state_t;

    state_t current_state, next_state;

    reg [7:0] first_byte;       // Holds first input byte
    reg       valid_out_dly;    // Delayed valid_out for one cycle after concatenation
    reg [15:0] data_out_reg;    // Holds concatenated data before output

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (valid_in) 
                    next_state = WAIT;
            end
            WAIT: begin
                if (valid_in)
                    next_state = IDLE;
            end
        endcase
    end

    // Data path and output valid signal handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte    <= 8'd0;
            data_out_reg  <= 16'd0;
            valid_out_dly <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            // Default outputs low unless updated
            valid_out <= valid_out_dly;

            valid_out_dly <= 1'b0;  // default to no output valid

            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        // Store first byte and wait for second
                        first_byte <= data_in;
                    end
                end

                WAIT: begin
                    if (valid_in) begin
                        // Concatenate first and second byte
                        data_out_reg <= {first_byte, data_in};
                        valid_out_dly <= 1'b1;  // signal output valid next cycle
                    end
                end
            endcase

            // Register output data one cycle after concatenation
            if (valid_out_dly) begin
                data_out <= data_out_reg;
            end else if (!valid_out_dly) begin
                // When no valid output, keep data_out stable or zero per spec
                // Here, we hold previous data_out; can also reset to zero if needed
            end
        end
    end

endmodule