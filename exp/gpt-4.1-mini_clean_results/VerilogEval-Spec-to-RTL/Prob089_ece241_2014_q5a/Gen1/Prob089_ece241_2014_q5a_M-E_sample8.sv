module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam STATE_ZERO   = 2'b00; // Before first 1
    localparam STATE_ONE    = 2'b01; // First 1 detected, output it this cycle
    localparam STATE_INVERT = 2'b10; // After first 1, invert bits

    reg [1:0] state, next_state;
    reg       next_z;

    // Next state and output logic (combinational)
    always @(*) begin
        case(state)
            STATE_ZERO: begin
                next_z = x; // output input bit
                if (x == 1'b1)
                    next_state = STATE_ONE;
                else
                    next_state = STATE_ZERO;
            end
            STATE_ONE: begin
                next_z = x; // output the first '1' unchanged
                next_state = STATE_INVERT;
            end
            STATE_INVERT: begin
                next_z = ~x; // invert bits after first 1
                next_state = STATE_INVERT;
            end
            default: begin
                next_z = 1'b0;
                next_state = STATE_ZERO;
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_ZERO;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule