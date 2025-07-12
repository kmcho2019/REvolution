module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM state encoding
    typedef enum logic [0:0] {
        WAIT_FIRST  = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;
    reg [7:0] first_byte_reg;

    // Registers to pipeline output valid and data by one cycle
    reg        valid_out_d;
    reg [15:0] data_out_d;

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= WAIT_FIRST;
            first_byte_reg <= 8'd0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
            valid_out_d    <= 1'b0;
            data_out_d     <= 16'd0;
        end else begin
            state <= next_state;

            // Pipeline output registers: transfer delayed output to output ports
            valid_out <= valid_out_d;
            data_out  <= data_out_d;

            case (state)
                WAIT_FIRST: begin
                    if (valid_in) begin
                        // Store first byte and move to WAIT_SECOND
                        first_byte_reg <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Capture output data (concatenation) into pipeline registers
                        data_out_d  <= {first_byte_reg, data_in};
                        valid_out_d <= 1'b1;
                    end else begin
                        // No valid input, no output update
                        valid_out_d <= 1'b0;
                    end
                end

                default: ;
            endcase

            // Clear output valid if no second input in WAIT_SECOND state
            if (state == WAIT_SECOND && !valid_in)
                valid_out_d <= 1'b0;
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            WAIT_FIRST: 
                next_state = valid_in ? WAIT_SECOND : WAIT_FIRST;

            WAIT_SECOND:
                next_state = valid_in ? WAIT_FIRST : WAIT_SECOND;

            default:
                next_state = WAIT_FIRST;
        endcase
    end

endmodule