module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Use enum for FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RECEIVE = 2'd1,
        STOP    = 2'd2,
        ERROR   = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1'b1) ? IDLE : ERROR;
            ERROR:   next_state = (in == 1'b1) ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    // Clock enable for shifting only in RECEIVE state
    wire shift_en = (state == RECEIVE);

    // Combinational done logic: done asserted only on correct stop bit detection
    wire done_next = (state == STOP) && (in == 1'b1);

    // Sequential state and data_reg update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; pulse generated for one cycle at STOP with valid stop bit
            done <= done_next;

            if (state == IDLE) begin
                bit_count <= 3'd0;
                data_reg  <= 8'd0;
            end else if (shift_en) begin
                // Shift in LSB first: shift right, insert new bit at MSB
                data_reg <= {in, data_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end
            // bit_count and data_reg held in other states
        end
    end

endmodule