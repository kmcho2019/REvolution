module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    typedef enum logic [1:0] {IDLE=2'b00, ACCUMULATE=2'b01} state_t;
    state_t state, next_state;

    reg [1:0] count;
    reg [9:0] sum;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = ACCUMULATE;
                else
                    next_state = IDLE;
            end
            ACCUMULATE: begin
                if (valid_in && (count == 2'd3))
                    next_state = IDLE;
                else
                    next_state = ACCUMULATE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, count, sum, output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            count     <= 2'd0;
            sum       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0; // default

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        sum   <= data_in;
                        count <= 2'd1;
                    end else begin
                        sum   <= 10'd0;
                        count <= 2'd0;
                    end
                end
                ACCUMULATE: begin
                    if (valid_in) begin
                        if (count == 2'd3) begin
                            data_out  <= sum + data_in;
                            valid_out <= 1'b1;
                            sum       <= 10'd0;
                            count     <= 2'd0;
                        end else begin
                            sum   <= sum + data_in;
                            count <= count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end

endmodule