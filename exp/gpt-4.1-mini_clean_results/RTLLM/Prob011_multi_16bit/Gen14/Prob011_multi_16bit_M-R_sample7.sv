module multi_16bit (
    input          clk,
    input          rst_n,    // active low synchronous reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        LOAD  = 2'b01,
        SHIFT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [15:0] areg;      // multiplicand register (shifted right)
    reg [31:0] breg;      // multiplier register (shifted left)
    reg [31:0] acc;       // accumulator register (product)
    reg [4:0]  count;     // 5-bit counter (0..16) sufficient for 16 shifts

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = start ? LOAD : IDLE;
            LOAD:  next_state = SHIFT;
            SHIFT: next_state = (count == 5'd16) ? DONE : SHIFT;
            DONE:  next_state = start ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Data path and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg  <= 16'd0;
            breg  <= 32'd0;
            acc   <= 32'd0;
            count <= 5'd0;
        end else begin
            case(state)
                IDLE: begin
                    areg  <= 16'd0;
                    breg  <= 32'd0;
                    acc   <= 32'd0;
                    count <= 5'd0;
                end

                LOAD: begin
                    areg  <= ain;
                    breg  <= {16'd0, bin};  // zero extend bin to 32 bits
                    acc   <= 32'd0;
                    count <= 5'd0;
                end

                SHIFT: begin
                    // If LSB of areg is 1, add breg to acc
                    if (areg[0])
                        acc <= acc + breg;
                    else
                        acc <= acc;

                    // Shift areg right by 1, breg left by 1
                    areg  <= areg >> 1;
                    breg  <= breg << 1;

                    count <= count + 5'd1;
                end

                DONE: begin
                    // Hold values, no changes to registers
                    areg  <= areg;
                    breg  <= breg;
                    acc   <= acc;
                    count <= count;
                end

                default: begin
                    areg  <= 16'd0;
                    breg  <= 32'd0;
                    acc   <= 32'd0;
                    count <= 5'd0;
                end
            endcase
        end
    end

    // done signal: asserted in DONE state
    assign done = (state == DONE);

    // output product
    assign yout = acc;

endmodule