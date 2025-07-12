module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam [1:0]
        IDLE     = 2'b00,
        RECEIVE  = 2'b01,
        STOP_WAIT= 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // 0 to 7
    reg [7:0] shift_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;    // valid stop bit or idle line regained
                else
                    next_state = STOP_WAIT; // wait for stop bit or idle
            end

            default: next_state = IDLE;
        endcase
    end

    // Bit counter and shift register updates
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 3'd1;
                end
                STOP_WAIT: begin
                    // no change to bit_count or shift_reg
                    bit_count <= 3'd0; 
                end
            endcase
        end
    end

    // done and out_byte logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else if (state == STOP_WAIT && in == 1'b1) begin
            done <= 1'b1;
            out_byte <= shift_reg;
        end else begin
            done <= 1'b0;
        end
    end

endmodule