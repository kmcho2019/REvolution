module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding using typedef for clarity and synthesis friendliness
    typedef enum logic [0:0] {
        BEFORE_ONE = 1'b0,
        AFTER_ONE  = 1'b1
    } state_t;

    state_t state, next_state;
    reg next_z;

    // Combinational logic for next state and Moore output (depends only on current state)
    always @(*) begin
        case (state)
            BEFORE_ONE: begin
                if (x == 1'b1) begin
                    next_state = AFTER_ONE;
                    next_z = 1'b1; // Copy the first '1'
                end else begin
                    next_state = BEFORE_ONE;
                    next_z = 1'b0; // Copy zeros before first '1'
                end
            end
            AFTER_ONE: begin
                next_state = AFTER_ONE;
                next_z = ~x; // Invert bits after first '1'
            end
            default: begin
                next_state = BEFORE_ONE;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: asynchronous reset, synchronous state and output update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_ONE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule