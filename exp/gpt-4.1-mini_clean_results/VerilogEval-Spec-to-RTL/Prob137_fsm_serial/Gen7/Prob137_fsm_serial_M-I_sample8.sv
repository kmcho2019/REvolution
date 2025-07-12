module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // Binary encoded FSM states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    wire receive_en = (state == RECEIVE);

    // Sequential logic: state, bit_count, shift_reg
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end else if (receive_en) begin
                // Shift left by 1, LSB first reception (new bit at LSB)
                shift_reg <= {shift_reg[6:0], in};
                bit_count <= bit_count + 1;
            end else if (state == WAIT_STOP) begin
                // Keep bit_count and shift_reg stable in WAIT_STOP
                bit_count <= bit_count;
                shift_reg <= shift_reg;
            end else begin
                // Hold bit_count and shift_reg otherwise
                bit_count <= bit_count;
                shift_reg <= shift_reg;
            end
        end
    end

    // Combinational next_state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP; // After 8 bits, check stop bit
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Correct stop bit: back to idle
                else
                    next_state = WAIT_STOP; // Framing error: wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Stop bit detected: resume idle
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Done signal combinational: pulse high only in CHECK_STOP with valid stop bit
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule