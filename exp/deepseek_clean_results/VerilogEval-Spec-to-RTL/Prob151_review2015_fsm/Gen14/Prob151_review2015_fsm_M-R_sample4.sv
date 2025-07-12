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
    localparam IDLE    = 4'b0001;
    localparam SHIFT   = 4'b0010;
    localparam COUNT   = 4'b0100;
    localparam DONE    = 4'b1000;
    
    reg [3:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;
    
    // Pattern detection wire
    wire pattern_match = (pattern_reg == 4'b1101);
    
    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = pattern_match ? SHIFT : IDLE;
            end
            SHIFT: begin
                next_state = (shift_count == 2'b11) ? COUNT : SHIFT;
            end
            COUNT: begin
                next_state = done_counting ? DONE : COUNT;
            end
            DONE: begin
                next_state = ack ? IDLE : DONE;
            end
            default: next_state = IDLE;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            state <= next_state;
            
            // Update pattern register only in IDLE state
            if (state == IDLE) begin
                pattern_reg <= {pattern_reg[2:0], data};
            end
            
            // Update shift counter only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'b0;
            end
        end
    end
    
    // Output assignments (direct from state bits)
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    
endmodule