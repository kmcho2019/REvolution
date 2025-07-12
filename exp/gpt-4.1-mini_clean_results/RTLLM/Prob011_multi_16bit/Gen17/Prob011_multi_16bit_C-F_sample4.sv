module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM state encoding
    localparam IDLE = 1'b0,
               BUSY = 1'b1;

    reg         state, next_state;
    reg [4:0]   count;           // shift count 0..16
    reg [31:0]  product;         // upper 16 bits partial sum, lower 16 bits multiplier bits
    reg [15:0]  multiplicand;
    reg         done_r;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = start ? BUSY : IDLE;
            BUSY:  next_state = (count == 5'd16) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, count, product, multiplicand, done
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            count        <= 5'd0;
            product      <= 32'd0;
            multiplicand <= 16'd0;
            done_r       <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done_r <= 1'b0;
                    count  <= 5'd0;
                    if (start) begin
                        multiplicand <= ain;
                        product     <= {16'd0, bin};
                        count       <= 5'd0; // Start counting on first BUSY cycle
                    end
                end

                BUSY: begin
                    count <= count + 5'd1;

                    // Shift and accumulate operation:
                    // If LSB of product is 1, add multiplicand (shifted to upper half) before shifting
                    if (product[0])
                        product <= (product >> 1) + ({multiplicand, 16'd0} >> 1);
                    else
                        product <= product >> 1;

                    // Assert done_r when count reaches 16 (last multiplication cycle)
                    done_r <= (count == 5'd15);
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule