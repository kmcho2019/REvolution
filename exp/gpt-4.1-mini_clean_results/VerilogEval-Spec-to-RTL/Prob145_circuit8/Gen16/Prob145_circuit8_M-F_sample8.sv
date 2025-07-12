module TopModule(
    input        clock,
    input        a,
    output reg   p,
    output reg   q
);

    reg [1:0] state;

    always @(posedge clock) begin
        // Assign outputs from previous state
        p <= state[1];
        q <= state[0];
        // Shift in new input a into state
        state <= {state[0], a};
    end

endmodule