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

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam SHIFT = 3'b010;
    localparam COUNT = 3'b100;
    
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
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                
                SHIFT: begin
                    if (shift_count == 2'b11) begin
                        state <= COUNT;
                    end
                    shift_count <= shift_count + 1'b1;
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                
                COUNT: begin
                    if (done_counting) begin
                        state <= IDLE;  // Transition to DONE handled by output
                    end
                    pattern_reg <= 4'b0;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == COUNT) && done_counting && !ack;

endmodule