module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding using localparams for clarity and minimal logic
    localparam WAIT_FOR_FIRST_ONE = 1'b0;
    localparam INVERT_BITS        = 1'b1;

    reg state, next_state;
    reg next_z;

    // Combinational logic to determine next state and output
    always @(*) begin
        case(state)
            WAIT_FOR_FIRST_ONE: begin
                next_z     = x;
                next_state = (x) ? INVERT_BITS : WAIT_FOR_FIRST_ONE;
            end
            INVERT_BITS: begin
                next_z     = ~x;
                next_state = INVERT_BITS;
            end
            default: begin
                next_z     = 1'b0;
                next_state = WAIT_FOR_FIRST_ONE;
            end
        endcase
    end

    // Sequential logic with asynchronous reset to update state and output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_FIRST_ONE;
            z     <= 1'b0;
        end else begin
            state <= next_state;
            z     <= next_z;
        end
    end

endmodule