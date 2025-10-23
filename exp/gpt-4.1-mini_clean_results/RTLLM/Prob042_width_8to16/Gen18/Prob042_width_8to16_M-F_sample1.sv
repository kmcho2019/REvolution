module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam WAIT = 1'b1;

    reg        state, next_state;
    reg [7:0]  data_lock;

    reg        valid_out_reg;
    reg [15:0] data_out_reg;

    // Output registers to hold next-cycle outputs
    reg        valid_out_next;
    reg [15:0] data_out_next;

    // State transition and data_lock update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            valid_out_reg<= 1'b0;
            data_out_reg <= 16'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out_reg <= 1'b0;  // no valid output in IDLE
                    data_out_reg <= data_out_reg; // keep stable

                    if (valid_in) begin
                        data_lock <= data_in;  // latch first byte
                    end
                end

                WAIT: begin
                    valid_out_reg <= valid_out_next;  // output registered from previous cycle
                    data_out_reg <= data_out_next;

                    if (valid_in) begin
                        // On second valid input: prepare output for next cycle
                        // Store concatenated data and assert valid_out next cycle
                        data_out_next <= {data_lock, data_in};
                        valid_out_next <= 1'b1;
                    end else begin
                        // No second valid input, no output
                        data_out_next <= 16'd0;
                        valid_out_next <= 1'b0;
                    end
                end
                default: begin
                    valid_out_reg <= 1'b0;
                    data_out_reg <= 16'd0;
                    data_lock <= 8'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT;
                else
                    next_state = IDLE;
            end
            WAIT: begin
                if (valid_in)
                    next_state = IDLE; // after second input go back to IDLE
                else
                    next_state = WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule