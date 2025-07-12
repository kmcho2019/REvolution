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

    // Combinational logic to determine next state and output using ternary operators
    always @(*) begin
        next_state = (state == WAIT_FOR_FIRST_ONE) ? (x ? INVERT_BITS : WAIT_FOR_FIRST_ONE) : INVERT_BITS;
        next_z     = (state == WAIT_FOR_FIRST_ONE) ? x : ~x;
    end

    // Sequential logic with asynchronous reset to update state and output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_FIRST_ONE;
            z     <= 1'b0; // Hold output steady during reset to reduce toggling
        end else begin
            state <= next_state;
            z     <= next_z;
        end
    end

endmodule