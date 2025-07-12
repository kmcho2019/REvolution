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
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg         state, next_state;
    reg [4:0]   count;          // counts from 0 to 16
    reg [31:0]  product;        // upper 16 bits partial sum, lower 16 bits multiplier bits
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

    // Sequential logic for FSM, counter, registers
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
                    count <= 5'd0;
                    if (start) begin
                        multiplicand <= ain;
                        product <= {16'd0, bin};  // Load multiplier in lower bits, upper bits zero
                    end else begin
                        // Keep registers stable if not starting
                        multiplicand <= multiplicand;
                        product <= product;
                    end
                end

                BUSY: begin
                    done_r <= (count == 5'd16);

                    // Perform shift and conditional add when count < 16
                    if (count < 5'd16) begin
                        if (product[0])
                            product <= (product >> 1) + ({multiplicand,16'd0} >> 1);
                        else
                            product <= product >> 1;
                        count <= count + 5'd1;
                    end else begin
                        // Multiplication complete, hold registers stable until FSM transitions
                        product <= product;
                        count <= count;
                    end
                end

                default: begin
                    done_r <= 1'b0;
                    count <= 5'd0;
                    product <= 32'd0;
                    multiplicand <= 16'd0;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule