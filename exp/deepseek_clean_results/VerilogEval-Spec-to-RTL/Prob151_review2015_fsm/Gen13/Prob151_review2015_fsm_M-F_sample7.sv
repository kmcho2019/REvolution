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

    // State encoding
    localparam IDLE      = 2'b00;
    localparam SHIFT     = 2'b01;
    localparam COUNTING  = 2'b10;
    localparam DONE      = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State transitions and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'b0;
            pattern <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        pattern <= 4'b0; // Clear pattern register
                    end
                end

                SHIFT: begin
                    if (shift_cnt == 2'b11) begin
                        state <= COUNTING;
                        shift_cnt <= 2'b0;
                    end else begin
                        shift_cnt <= shift_cnt + 1;
                    end
                end

                COUNTING: begin
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule