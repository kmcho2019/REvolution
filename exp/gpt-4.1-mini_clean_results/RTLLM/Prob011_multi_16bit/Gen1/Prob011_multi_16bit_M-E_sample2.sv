module multi_16bit (
    input             clk,
    input             rst_n,
    input             start,
    input      [15:0] ain,
    input      [15:0] bin,
    output reg [31:0] yout,
    output            done
);

// FSM states
localparam IDLE = 1'b0;
localparam RUN  = 1'b1;

reg state, next_state;

// Registers for multiplicand, multiplier, and product accumulator
reg [31:0] multiplicand;
reg [15:0] multiplier;
reg [31:0] product;

reg [4:0] count; // counts from 0 to 16 (need 5 bits)

// FSM sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= IDLE;
        multiplicand<= 32'd0;
        multiplier  <= 16'd0;
        product     <= 32'd0;
        count       <= 5'd0;
        yout        <= 32'd0;
    end else begin
        state <= next_state;

        case (state)
            IDLE: begin
                yout <= yout; // hold
                if (start) begin
                    multiplicand <= {16'd0, ain}; // zero-extend to 32 bits
                    multiplier   <= bin;
                    product      <= 32'd0;
                    count        <= 5'd0;
                end
            end
            RUN: begin
                // Shift and accumulate step
                if (multiplier[0])
                    product <= product + multiplicand;
                else
                    product <= product;

                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;

                count <= count + 1;

                // Update yout at the end of RUN
                if (count == 5'd15) // after completing 16 cycles (0 to 15)
                    yout <= product + (multiplier[0] ? multiplicand : 32'd0);
                else
                    yout <= yout;
            end
        endcase
    end
end

// FSM next state logic
always @(*) begin
    case (state)
        IDLE: next_state = start ? RUN : IDLE;
        RUN:  next_state = (count == 5'd16) ? IDLE : RUN;
        default: next_state = IDLE;
    endcase
end

// done flag: asserted when multiplication finished (returning to IDLE from RUN after 16 cycles)
reg done_r;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done_r <= 1'b0;
    else if (state == RUN && count == 5'd16)
        done_r <= 1'b1;
    else if (state == IDLE)
        done_r <= 1'b0;
end
assign done = done_r;

endmodule