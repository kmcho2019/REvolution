module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding using reg (simple 1-bit state)
    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;
    reg [7:0] first_byte_reg;

    // Pipeline registers for output valid and data
    reg valid_out_d;
    reg [15:0] data_out_d;

    // Sequential logic: state and registers update
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

            // Transfer delayed outputs to output ports
            valid_out <= valid_out_d;
            data_out  <= data_out_d;

            case (state)
                WAIT_FIRST: begin
                    if (valid_in) begin
                        // Store first byte, no output yet
                        first_byte_reg <= data_in;
                        valid_out_d    <= 1'b0;
                        data_out_d     <= 16'd0;
                    end else begin
                        // No valid input, keep pipeline outputs cleared
                        valid_out_d <= 1'b0;
                        data_out_d  <= 16'd0;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate stored first byte and new byte
                        data_out_d  <= {first_byte_reg, data_in};
                        valid_out_d <= 1'b1;  // Output valid one cycle later
                    end else begin
                        // No second valid input, output not valid
                        valid_out_d <= 1'b0;
                        data_out_d  <= 16'd0;
                    end
                end

                default: begin
                    valid_out_d <= 1'b0;
                    data_out_d  <= 16'd0;
                end
            endcase
        end
    end

    // Combinational logic: next state decision
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