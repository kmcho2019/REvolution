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
    localparam IDLE    = 2'b00;
    localparam SHIFT   = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;
    
    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;
    
    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    shift_count <= 2'b0;
                end
                
                SHIFT: begin
                    shift_count <= shift_count + 1'b1;
                end
                
                default: begin
                    // Maintain values in other states
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin
                if (shift_count == 2'b11) begin
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
    
    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule