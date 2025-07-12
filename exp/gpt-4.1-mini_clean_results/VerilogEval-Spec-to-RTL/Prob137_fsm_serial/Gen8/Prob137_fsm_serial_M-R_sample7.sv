module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // FSM states encoding
    localparam IDLE       = 3'd0;
    localparam RECEIVE    = 3'd1;
    localparam CHECK_STOP = 3'd2;
    localparam WAIT_STOP  = 3'd3;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset || state != RECEIVE)
            bit_count <= 3'd0;
        else
            bit_count <= bit_count + 1'b1;
    end

    // Shift register shifts in LSB-first bits: shift right and input new bit into MSB
    always @(posedge clk) begin
        if (reset || state != RECEIVE)
            shift_reg <= 8'd0;
        else
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Done is combinational: pulse high for one cycle when stop bit is correct in CHECK_STOP
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule