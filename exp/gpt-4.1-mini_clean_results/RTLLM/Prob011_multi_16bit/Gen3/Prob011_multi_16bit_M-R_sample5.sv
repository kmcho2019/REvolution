module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        LOAD  = 2'b01,
        SHIFT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t       state, next_state;
    reg [4:0]     bit_pos;       // bit counter from 0 to 16 (max 16 bits)
    reg [31:0]    product_acc;   // product accumulator
    reg [15:0]    multiplicand;  // multiplicand register (areg)
    reg [15:0]    multiplier;    // multiplier register (breg)

    // FSM sequential block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            bit_pos     <= 5'd0;
            product_acc <= 32'd0;
            multiplicand<= 16'd0;
            multiplier  <= 16'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_pos     <= 5'd0;
                    product_acc <= 32'd0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier   <= bin;
                    end
                end

                LOAD: begin
                    bit_pos     <= 5'd0;
                    product_acc <= 32'd0;
                    multiplicand <= ain;
                    multiplier   <= bin;
                end

                SHIFT: begin
                    // Check current bit of multiplicand and add shifted multiplier accordingly
                    if (multiplicand[bit_pos])
                        product_acc <= product_acc + (multiplier << bit_pos);
                    else
                        product_acc <= product_acc;

                    bit_pos <= bit_pos + 1'b1;
                end

                DONE: begin
                    // Hold product and counters
                    product_acc <= product_acc;
                    bit_pos <= bit_pos;
                end

                default: begin
                    state       <= IDLE;
                    bit_pos     <= 5'd0;
                    product_acc <= 32'd0;
                    multiplicand<= 16'd0;
                    multiplier  <= 16'd0;
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = start ? LOAD : IDLE;

            LOAD:  next_state = SHIFT;

            SHIFT: next_state = (bit_pos == 5'd16) ? DONE : SHIFT;

            DONE:  next_state = start ? LOAD : IDLE;

            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign yout = product_acc;
    assign done = (state == DONE);

endmodule