module accu (
    input          clk,
    input          rst_n,
    input  [7:0]   data_in,
    input          valid_in,
    output reg     valid_out,
    output reg [9:0] data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ACCUMULATE = 2'b01
    } state_t;

    state_t state, next_state;
    reg [9:0] sum_reg;
    reg [1:0] count_reg;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = ACCUMULATE;
                else
                    next_state = IDLE;
            end
            ACCUMULATE: begin
                if (valid_in && (count_reg == 2'd3))
                    next_state = IDLE;
                else
                    next_state = ACCUMULATE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            sum_reg    <= 10'd0;
            count_reg  <= 2'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0; // default low unless outputting

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        sum_reg   <= data_in;
                        count_reg <= 2'd1;
                    end else begin
                        sum_reg   <= 10'd0;
                        count_reg <= 2'd0;
                    end
                end
                ACCUMULATE: begin
                    if (valid_in) begin
                        sum_reg   <= sum_reg + data_in;
                        count_reg <= count_reg + 1'b1;
                        if (count_reg == 2'd3) begin
                            data_out  <= sum_reg + data_in;
                            valid_out <= 1'b1;
                            sum_reg   <= 10'd0;
                            count_reg <= 2'd0;
                        end
                    end
                end
            endcase
        end
    end

endmodule