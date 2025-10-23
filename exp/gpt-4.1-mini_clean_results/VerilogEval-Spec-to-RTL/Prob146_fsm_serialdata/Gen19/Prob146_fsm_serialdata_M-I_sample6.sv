module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM state encoding (binary)
    localparam IDLE       = 2'd0;
    localparam READ_BITS  = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    wire shift_enable;

    assign shift_enable = (state == READ_BITS);

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            if (shift_enable) begin
                // Shift left and insert new bit at LSB for LSB first reception
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end else begin
                bit_cnt <= 3'd0;
                if (state == IDLE) begin
                    shift_reg <= 8'd0;
                end
            end

            // On CHECK_STOP state, validate stop bit and pulse done
            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    out_byte <= shift_reg;
                    done <= 1'b1; // pulse done for one clock
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = READ_BITS;
                else
                    next_state = IDLE;
            end

            READ_BITS: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = READ_BITS;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule