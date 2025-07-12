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
    localparam [1:0] 
        IDLE     = 2'b00,
        SHIFTING = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern_reg;

    // Shift register for pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter
    always @(posedge clk) begin
        if (reset || state != SHIFTING) begin
            shift_cnt <= 2'b11; // Count down from 3 (4 cycles)
        end else if (state == SHIFTING) begin
            shift_cnt <= shift_cnt - 1;
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101)
                        state <= SHIFTING;
                end
                
                SHIFTING: begin
                    if (shift_cnt == 2'b00)
                        state <= COUNTING;
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

    // Combinational outputs
    assign shift_ena = (state == SHIFTING);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule