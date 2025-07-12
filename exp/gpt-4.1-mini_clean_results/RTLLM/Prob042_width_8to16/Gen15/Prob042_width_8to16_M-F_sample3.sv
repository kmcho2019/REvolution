module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT      = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] first_byte;
    reg [7:0] second_byte;

    // On reset or clock edge: update state and registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            first_byte  <= 8'd0;
            second_byte <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;

            // Default valid_out deasserted
            valid_out <= 1'b0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in;
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        second_byte <= data_in;
                    end
                end
                OUTPUT: begin
                    // Output data one cycle after second byte arrival
                    data_out  <= {first_byte, second_byte};
                    valid_out <= 1'b1;
                end
                default: ;
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
                    next_state = OUTPUT;
                else
                    next_state = WAIT_SECOND;
            end
            OUTPUT: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule