module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

    wire next_state;

    // Combinational next state logic based on current state and inputs
    assign next_state = (state == 1'b0) ? (~a & b) : ~(a & ~b);

    // Sequential state update on positive clock edge
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output q reflects next_state combinationally
    assign q = next_state;

endmodule