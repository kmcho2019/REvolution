module TopModule(
    input  wire x,
    input  wire y,
    output reg  z
);

    // Define states
    localparam EQUAL     = 1'b1;
    localparam NOT_EQUAL = 1'b0;

    // Internal state register inferred by always block triggered by x or y
    reg state;

    always @(x or y) begin
        if (x == y)
            state = EQUAL;
        else
            state = NOT_EQUAL;
    end

    // Output z is high when in EQUAL state
    always @(state) begin
        z = (state == EQUAL) ? 1'b1 : 1'b0;
    end

endmodule