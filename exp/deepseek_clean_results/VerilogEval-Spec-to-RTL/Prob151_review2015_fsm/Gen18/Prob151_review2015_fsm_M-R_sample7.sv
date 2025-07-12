module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // Binary state encoding
    localparam [2:0] 
        IDLE        = 3'b000,
        SHIFT       = 3'b001,
        COUNTING    = 3'b010,
        DONE        = 3'b011,
        WAIT_ACK    = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end

                SHIFT: begin
                    shift_count <= shift_count + 1;
                    if (shift_count == 2'b11)
                        state <= COUNTING;
                end

                COUNTING: begin
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    state <= WAIT_ACK;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE) || (state == WAIT_ACK);

endmodule