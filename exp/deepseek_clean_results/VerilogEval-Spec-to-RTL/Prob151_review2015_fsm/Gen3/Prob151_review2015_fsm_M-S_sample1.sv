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

    // Simplified state encoding
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 0;
            pattern <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_cnt <= 0;
                    end
                end
                
                SHIFT: begin
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 3) begin
                        state <= COUNTING;
                    end
                end
                
                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 0;
                    end
                end
            endcase
        end
    end

    // Simplified output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule