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
    localparam IDLE = 2'd0,
               RUN  = 2'd1,
               DONE = 2'd2;

    reg [1:0] state, next_state;

    reg [4:0]  count;      // shift count 0 to 16
    reg [31:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] product;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = start ? RUN : IDLE;
            RUN:   next_state = (count == 5'd16) ? DONE : RUN;
            DONE:  next_state = start ? DONE : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Control signals and counters
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else begin
            case (state)
                IDLE:   count <= 5'd0;
                RUN:    count <= count + 5'd1;
                DONE:   count <= count; // hold count in DONE
                default: count <= 5'd0;
            endcase
        end
    end

    // Datapath: multiplicand, multiplier, product update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 32'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= {16'd0, ain};
                        multiplier   <= bin;
                        product      <= 32'd0;
                    end
                end
                RUN: begin
                    // If LSB of multiplier is 1, add multiplicand to product
                    if (multiplier[0])
                        product <= product + multiplicand;
                    else
                        product <= product;
                    // Shift multiplicand left by 1 for next bit weight
                    multiplicand <= multiplicand << 1;
                    // Shift multiplier right by 1 to process next bit
                    multiplier <= multiplier >> 1;
                end
                DONE: begin
                    // Hold outputs, no changes
                    multiplicand <= multiplicand;
                    multiplier <= multiplier;
                    product <= product;
                end
                default: begin
                    multiplicand <= 32'd0;
                    multiplier   <= 16'd0;
                    product      <= 32'd0;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = (state == DONE);

endmodule