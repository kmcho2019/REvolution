module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter and shift register update
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            if (state == IDLE) begin
                bit_cnt <= 3'd0;
                shift_reg <= 8'd0;
            end else if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]}; // shift LSB-first data in MSB side
                bit_cnt <= bit_cnt + 3'd1;
            end else if (state == CHECK_STOP || state == RECOVER) begin
                bit_cnt <= 3'd0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_cnt == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : RECOVER;
            RECOVER:    next_state = (in == 1'b1) ? IDLE : RECOVER;
            default:    next_state = IDLE;
        endcase
    end

    // Output logic: done pulse and output byte latch
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            if (state == CHECK_STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;  // pulse done for one cycle when valid stop bit detected
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule