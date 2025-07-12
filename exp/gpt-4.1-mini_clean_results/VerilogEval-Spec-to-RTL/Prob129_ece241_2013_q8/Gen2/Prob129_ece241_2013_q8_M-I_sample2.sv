module TopModule (
    input clk,
    input aresetn,  // active low async reset
    input x,
    output reg z
);

    // One-hot state encoding for 3 states
    localparam S0 = 3'b001,
               S1 = 3'b010,
               S2 = 3'b100;

    reg [2:0] state, next_state;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy): z = 1 only when state is S2 and x=1
    always @(*) begin
        z = (state == S2) && x;
    end

endmodule