module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_FIRST_ONE = 1'b0;
    localparam AFTER_FIRST_ONE  = 1'b1;

    reg state, next_state;
    reg next_z;

    // Combinational logic for next state and next output (Moore output)
    always @(*) begin
        next_state = state;
        next_z = 1'b0;
        case (state)
            BEFORE_FIRST_ONE: begin
                next_z = x; // output input bit until first '1'
                if (x == 1'b1)
                    next_state = AFTER_FIRST_ONE;
            end
            AFTER_FIRST_ONE: begin
                next_z = ~x; // invert bits after first '1'
                // remain in AFTER_FIRST_ONE
            end
        endcase
    end

    // Sequential logic: state and output registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_FIRST_ONE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule