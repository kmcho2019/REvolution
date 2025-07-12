module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding of states (6 bits)
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next-state combinational logic using continuous assignments
    // Each next_state bit is assigned based on current state bits and input w
    wire a = state[0];
    wire b = state[1];
    wire c = state[2];
    wire d = state[3];
    wire e = state[4];
    wire f = state[5];

    assign next_state[0] = (a && !w) || (d && !w);                 // A: from A(0->0) or D(0->0)
    assign next_state[1] = (a && w);                                // B: from A(0->1)
    assign next_state[2] = (b && w) || (f && w);                   // C: from B(0->1), F(1->1)
    assign next_state[3] = (b && !w) || (c && !w) || (e && !w) || (f && !w); // D: from B(0->0), C(0->0), E(1->0), F(1->0)
    assign next_state[4] = (c && w) || (e && w);                   // E: from C(0->1), E(1->1)
    assign next_state[5] = (d && w);                                // F: from D(0->1)

    // State register: synchronous reset and update every clock cycle
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z asserted when in state E or F
    assign z = state[4] | state[5];

endmodule