module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot encoded FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP:  next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:    next_state = IDLE;
        endcase
    end

    // bit_count register: increment during RECEIVE, reset otherwise
    always @(posedge clk) begin
        if (reset || state == IDLE || state == WAIT_STOP)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 1'b1;
    end

    // Shift register: shift right, input bit goes to MSB (still LSB first overall)
    always @(posedge clk) begin
        if (reset || state == IDLE || state == WAIT_STOP)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // done signal combinational: high one cycle when stop bit valid in CHECK_STOP
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule