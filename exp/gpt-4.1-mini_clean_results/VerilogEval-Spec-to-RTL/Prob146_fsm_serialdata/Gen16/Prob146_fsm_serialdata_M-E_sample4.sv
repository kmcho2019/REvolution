module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding for FSM: IDLE + 8 data bits + STOP + ERROR_WAIT = 11 states
    // Using 11-bit one-hot register (bit position corresponds to state)
    localparam IDLE       = 11'b00000000001;
    localparam BIT0       = 11'b00000000010;
    localparam BIT1       = 11'b00000000100;
    localparam BIT2       = 11'b00000001000;
    localparam BIT3       = 11'b00000010000;
    localparam BIT4       = 11'b00000100000;
    localparam BIT5       = 11'b00001000000;
    localparam BIT6       = 11'b00010000000;
    localparam BIT7       = 11'b00100000000;
    localparam STOP       = 11'b01000000000;
    localparam ERROR_WAIT = 11'b10000000000;

    reg [10:0] state, next_state;
    reg [7:0]  shift_reg;

    // State register
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
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = BIT0;
                else
                    next_state = IDLE;
            end
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = BIT3;
            BIT3: next_state = BIT4;
            BIT4: next_state = BIT5;
            BIT5: next_state = BIT6;
            BIT6: next_state = BIT7;
            BIT7: next_state = STOP;
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit, ready for next byte
                else
                    next_state = ERROR_WAIT; // Invalid stop bit, error recovery
            end
            ERROR_WAIT: begin
                // Wait until line idle before looking for new start bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Shift register: build byte LSB first by shifting left and putting new bit in LSB
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else begin
            // Shift in data bits only when in BIT0 to BIT7 states
            if (state == BIT0)
                shift_reg <= {7'd0, in}; // first bit shifted in
            else if ((state & (BIT1|BIT2|BIT3|BIT4|BIT5|BIT6|BIT7)) != 0)
                shift_reg <= {in, shift_reg[7:1]}; // shift previous left, new bit in MSB
            else if (state == IDLE)
                shift_reg <= 8'd0; // clear in idle for safety
        end
    end

    // done and out_byte output logic
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

endmodule