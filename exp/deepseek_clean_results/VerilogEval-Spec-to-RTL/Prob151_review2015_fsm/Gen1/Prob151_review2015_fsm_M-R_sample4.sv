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

    // One-hot encoded states
    localparam IDLE      = 4'b0001;
    localparam SHIFT     = 4'b0010;
    localparam COUNTING  = 4'b0100;
    localparam DONE      = 4'b1000;
    
    reg [3:0] state;
    reg [3:0] pattern_reg;  // Shift register for pattern detection
    reg [1:0] shift_count;  // Counter for shift cycles
    
    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end
    
    // Shift counter
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_count <= 2'b0;
        end else begin
            shift_count <= shift_count + 1;
        end
    end
    
    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101)
                        state <= SHIFT;
                end
                
                SHIFT: begin
                    if (shift_count == 2'b11)
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
                
                default: state <= IDLE;
            endcase
        end
    end
    
    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);
    
endmodule