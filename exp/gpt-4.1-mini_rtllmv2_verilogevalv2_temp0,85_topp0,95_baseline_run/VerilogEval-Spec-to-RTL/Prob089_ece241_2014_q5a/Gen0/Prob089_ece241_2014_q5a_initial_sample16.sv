module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// State encoding
localparam BEFORE_ONES = 1'b0;
localparam AFTER_ONES  = 1'b1;

reg state, next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) 
        state <= BEFORE_ONES;
    else 
        state <= next_state;
end

// Next state logic and output logic (Moore: output depends only on state and input)
always @(*) begin
    case(state)
        BEFORE_ONES: begin
            // Output is the input bit until first '1' encountered
            z = x;
            // If input bit is '1', move to AFTER_ONES
            if (x == 1'b1)
                next_state = AFTER_ONES;
            else
                next_state = BEFORE_ONES;
        end
        AFTER_ONES: begin
            // Output is inverted input bit
            z = ~x;
            // Stay in AFTER_ONES
            next_state = AFTER_ONES;
        end
        default: begin
            z = 1'b0;
            next_state = BEFORE_ONES;
        end
    endcase
end

endmodule