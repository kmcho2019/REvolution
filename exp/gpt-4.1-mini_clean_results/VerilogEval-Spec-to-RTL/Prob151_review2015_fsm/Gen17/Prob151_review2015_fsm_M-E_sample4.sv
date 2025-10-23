module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot state encoding
    localparam IDLE   = 7'b0000001,
               SHIFT0 = 7'b0000010,
               SHIFT1 = 7'b0000100,
               SHIFT2 = 7'b0001000,
               SHIFT3 = 7'b0010000,
               COUNT  = 7'b0100000,
               DONE   = 7'b1000000;

    reg [6:0] state, next_state;

    // 4-bit shift register for input pattern detection
    reg [3:0] pattern_reg;

    // Update pattern_reg each clock cycle
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0000;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = IDLE; // default

        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT0;
                else
                    next_state = IDLE;
            end

            SHIFT0: next_state = SHIFT1;
            SHIFT1: next_state = SHIFT2;
            SHIFT2: next_state = SHIFT3;
            SHIFT3: next_state = COUNT;

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Outputs logic
    assign shift_ena = (state == SHIFT0) || (state == SHIFT1) || (state == SHIFT2) || (state == SHIFT3);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule