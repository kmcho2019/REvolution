module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       in,
    output reg  [7:0] out_byte,
    output reg        done
);

    typedef enum reg [2:0] {
        IDLE  = 3'd0,
        DATA  = 3'd1,
        STOP  = 3'd2,
        ERROR = 3'd3
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Synchronous state register and counters
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // Default done low

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift in LSB first: new bit goes into MSB end when shifting right
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done     <= 1'b1;
                    end
                end

                ERROR: begin
                    // wait for line to return to idle high
                    // No special register updates
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule