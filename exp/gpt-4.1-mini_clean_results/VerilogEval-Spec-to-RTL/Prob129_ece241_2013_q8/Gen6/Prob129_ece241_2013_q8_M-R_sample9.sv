module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding using parameters
    localparam S0 = 2'b00; // initial state, no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // State register with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output combinational logic as continuous assignment
    // Output is 1 only when current state is S2 and input x is 1 (sequence detected)
    assign z = (state == S2) && (x == 1'b1);

endmodule