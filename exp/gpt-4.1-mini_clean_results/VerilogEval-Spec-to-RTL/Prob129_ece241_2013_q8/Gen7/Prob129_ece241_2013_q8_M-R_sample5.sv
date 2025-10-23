module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding for three states
    localparam S0 = 3'b001; // initial state, no bits matched
    localparam S1 = 3'b010; // matched '1'
    localparam S2 = 3'b100; // matched "10"

    reg [2:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register and output update, async negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output is asserted when current state is S2 and input x=1 (detect '101')
            z <= (state == S2) && (x == 1'b1);
        end
    end

endmodule