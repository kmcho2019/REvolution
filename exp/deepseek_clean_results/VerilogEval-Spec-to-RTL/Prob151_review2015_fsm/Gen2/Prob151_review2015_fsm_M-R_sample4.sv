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
    localparam S_IDLE      = 3'b000;
    localparam S_DETECT    = 3'b001;
    localparam S_SHIFT     = 3'b010;
    localparam S_COUNTING  = 3'b011;
    localparam S_DONE      = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_cnt;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_reg <= 4'b0;
            shift_cnt <= 2'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= S_SHIFT;
                        shift_cnt <= 2'b0;
                    end
                end
                
                S_SHIFT: begin
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 2'b11) begin
                        state <= S_COUNTING;
                    end
                end
                
                S_COUNTING: begin
                    if (done_counting) begin
                        state <= S_DONE;
                    end
                end
                
                S_DONE: begin
                    if (ack) begin
                        state <= S_IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
                
                default: state <= S_IDLE;
            endcase
        end
    end

    // Continuous output assignments
    assign shift_ena = (state == S_SHIFT);
    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);

endmodule