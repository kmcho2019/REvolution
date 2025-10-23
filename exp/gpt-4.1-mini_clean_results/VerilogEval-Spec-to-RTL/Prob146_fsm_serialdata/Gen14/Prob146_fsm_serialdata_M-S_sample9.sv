module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam IDLE       = 2'd0;
    localparam READ_BITS  = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State register and bit counter
    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            done    <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            if (state == READ_BITS) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end else begin
                bit_cnt <= 3'd0;
                if (state == IDLE)
                    shift_reg <= 8'd0;
            end

            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    out_byte <= shift_reg;
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:       next_state = (in == 1'b0) ? READ_BITS : IDLE;
            READ_BITS:  next_state = (bit_cnt == 3'd7) ? CHECK_STOP : READ_BITS;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : RECOVER;
            RECOVER:    next_state = (in == 1'b1) ? IDLE : RECOVER;
            default:    next_state = IDLE;
        endcase
    end

endmodule