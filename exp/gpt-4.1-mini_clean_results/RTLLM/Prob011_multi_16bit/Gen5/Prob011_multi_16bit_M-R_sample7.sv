module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t       state, next_state;
    reg [4:0]     count;          // shift count from 0 to 16
    reg [31:0]    product_reg;
    reg [15:0]    multiplier_reg;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = start ? RUNNING : IDLE;
            RUNNING: next_state = (count == 5'd16) ? DONE : RUNNING;
            DONE:    next_state = start ? RUNNING : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd0;
        else begin
            case (state)
                IDLE:    count <= 5'd0;
                RUNNING: count <= count + 5'd1;
                DONE:    count <= 5'd0;
                default: count <= 5'd0;
            endcase
        end
    end

    // Registers update (multiplicand, multiplier, product)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplier_reg <= 16'd0;
            product_reg    <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    multiplier_reg <= 16'd0;
                    product_reg    <= 32'd0;
                end
                RUNNING: begin
                    if (count == 5'd0) begin
                        multiplier_reg <= bin;
                        product_reg    <= 32'd0;
                    end else begin
                        if (multiplier_reg[0])
                            product_reg <= product_reg + (ain << (count - 1));
                        // Shift multiplier right by 1 bit each cycle after count 0
                        multiplier_reg <= multiplier_reg >> 1;
                    end
                end
                DONE: begin
                    // Hold values
                    multiplier_reg <= multiplier_reg;
                    product_reg    <= product_reg;
                end
                default: begin
                    multiplier_reg <= 16'd0;
                    product_reg    <= 32'd0;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = product_reg;
    assign done = (state == DONE);

endmodule