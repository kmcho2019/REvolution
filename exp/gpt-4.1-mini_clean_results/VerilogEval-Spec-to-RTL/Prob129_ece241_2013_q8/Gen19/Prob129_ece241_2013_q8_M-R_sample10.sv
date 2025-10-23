module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // One-hot encoding for 3 states
    // S0 = 3'b001 : no match
    // S1 = 3'b010 : matched '1'
    // S2 = 3'b100 : matched "10"
    reg [2:0] state;

    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];

    // Next state logic as combinational continuous assignments
    wire ns0, ns1, ns2;

    assign ns0 = (s0 && ~x) || (s2 && ~x);
    assign ns1 = (s0 && x) || (s1 && x) || (s2 && x);
    assign ns2 = s1 && ~x;

    // Mealy output: z asserted when in state S2 and input x=1
    assign z = s2 && x;

    // State update with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= 3'b001; // S0
        else
            state <= {ns2, ns1, ns0};
    end

endmodule