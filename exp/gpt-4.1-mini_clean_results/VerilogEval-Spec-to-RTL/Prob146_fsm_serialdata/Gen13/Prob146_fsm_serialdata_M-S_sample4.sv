module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    localparam IDLE    = 2'b00,
               RECEIVE = 2'b01,
               STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset || state != RECEIVE)
            bit_cnt <= 3'd0;
        else
            bit_cnt <= bit_cnt + 3'd1;
    end

    // Shift register: shift right, new bit at MSB for LSB first serial input
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
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
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1) // stop bit valid or idle line
                    next_state = IDLE;
                else
                    next_state = STOP; // wait for line idle
            end

            default: next_state = IDLE;
        endcase
    end

endmodule