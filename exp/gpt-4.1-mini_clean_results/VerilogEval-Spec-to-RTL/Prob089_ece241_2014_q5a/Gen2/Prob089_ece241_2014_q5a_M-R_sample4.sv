module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding using parameters
    localparam WAIT_FOR_FIRST_ONE = 1'b0;
    localparam INVERT_BITS        = 1'b1;

    reg state;

    // Combinational logic for next state
    wire next_state = (state == WAIT_FOR_FIRST_ONE && x == 1'b1) ? INVERT_BITS : state;

    // Combinational logic for output based on current state and input
    wire next_z = (state == WAIT_FOR_FIRST_ONE) ? x : ~x;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_FIRST_ONE;
        else
            state <= next_state;
    end

    // Output register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else
            z <= next_z;
    end

endmodule