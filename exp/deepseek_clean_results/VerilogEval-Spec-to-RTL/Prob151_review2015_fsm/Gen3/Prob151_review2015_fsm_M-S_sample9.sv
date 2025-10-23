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
    localparam [1:0] 
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) state <= SHIFT;
                end
                
                SHIFT: begin
                    if (&pattern_reg[1:0]) state <= COUNTING; // After 2 more shifts (total 4)
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                
                COUNTING: begin
                    if (done_counting) state <= DONE;
                end
                
                DONE: begin
                    if (ack) state <= IDLE;
                end
            endcase
        end
    end

    // Combinational outputs
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule