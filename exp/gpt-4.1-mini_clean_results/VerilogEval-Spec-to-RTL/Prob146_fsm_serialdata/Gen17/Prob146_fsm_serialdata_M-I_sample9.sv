module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot encoded states for faster next state decoding and simpler logic
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP       = 4'b0100;
    localparam ERROR_WAIT = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // FSM state register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: enabled only in RECEIVE state to reduce toggling
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == RECEIVE)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: enabled only in RECEIVE state
    // Shift left to put serial LSB-first bit into bit 0
    // shift_reg[7:1] <= old bits, shift_reg[0] <= new input bit
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]}; // Note: previous approach shifted right; here we shift left
        else if (state == IDLE)
            shift_reg <= shift_reg; // hold value to avoid toggling reset every cycle in IDLE
    end

    // Next state logic combinational block
    always @(*) begin
        next_state = state; // default hold state
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
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: done asserted when valid stop bit is received
    // Moore output: depends only on current state and input
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