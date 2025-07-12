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

    reg        state, next_state;
    reg [4:0]  count;        // Counts from 0 to 16 (16 steps)
    reg [15:0] areg;         // Multiplicand shift register
    reg [31:0] breg_ext;     // Multiplier extended and shifted
    reg [31:0] accumulator;  // Accumulates partial sum

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = BUSY;
                else
                    next_state = IDLE;
            end
            BUSY: begin
                if (count == 5'd16)
                    next_state = IDLE;
                else
                    next_state = BUSY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd0;
        else if (state == IDLE && start)
            count <= 5'd0;
        else if (state == BUSY)
            count <= count + 5'd1;
        else
            count <= 5'd0;
    end

    // Registers update during multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg        <= 16'd0;
            breg_ext    <= 32'd0;
            accumulator <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        areg        <= ain;
                        breg_ext    <= {16'd0, bin};
                        accumulator <= 32'd0;
                    end else begin
                        areg        <= 16'd0;
                        breg_ext    <= 32'd0;
                        accumulator <= 32'd0;
                    end
                end
                BUSY: begin
                    // If LSB of areg is 1, accumulate breg_ext to accumulator
                    if (areg[0])
                        accumulator <= accumulator + breg_ext;
                    else
                        accumulator <= accumulator;  // Hold value explicitly (optional)
                    // Shift areg right by 1 and breg_ext left by 1
                    areg     <= areg >> 1;
                    breg_ext <= breg_ext << 1;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = accumulator;
    assign done = (state == IDLE) && (count == 5'd16);

endmodule