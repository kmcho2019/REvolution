module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output wire       done
);

    // FSM state encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state and outputs combinational logic (Mealy style)
    reg done_next;
    reg [7:0] out_byte_next;

    always @(*) begin
        // Default assignments
        next_state    = state;
        done_next     = 1'b0;
        out_byte_next = out_byte;

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done_next = 1'b1;
                    out_byte_next = shift_reg;
                end else begin
                    next_state = ERROR_WAIT;
                end
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: increment only during RECEIVE state; reset on reset
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == RECEIVE)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift left (LSB first), input bit goes into bit 0 during RECEIVE
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output registers: latch done and out_byte when done asserted (Mealy done signal registered here)
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
        end else if (done_next) begin
            out_byte <= out_byte_next;
        end
    end

    // done output is a combinational signal derived from next state logic
    assign done = done_next;

endmodule