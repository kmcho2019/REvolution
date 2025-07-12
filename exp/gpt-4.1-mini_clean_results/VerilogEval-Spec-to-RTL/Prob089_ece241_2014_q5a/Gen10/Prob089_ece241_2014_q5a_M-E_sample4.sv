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

    // Next state logic and output logic (combinational)
    always @(*) begin
        case(state)
            BEFORE_FIRST_ONE: begin
                if (x == 1'b1) begin
                    next_state = AFTER_FIRST_ONE;
                    next_z = 1'b1;        // Output = input bit (1)
                end else begin
                    next_state = BEFORE_FIRST_ONE;
                    next_z = 1'b0;        // Output = input bit (0)
                end
            end
            AFTER_FIRST_ONE: begin
                next_state = AFTER_FIRST_ONE;
                next_z = ~x;               // Output inverted input bit
            end
            default: begin
                next_state = BEFORE_FIRST_ONE;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: state and output registers with asynchronous reset
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