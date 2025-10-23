module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding using localparam
    localparam S0 = 2'b00; // no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] state, next_state;

    // Sequential logic: state register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state generation
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Combinational logic: Mealy output generation
    always @(*) begin
        z = 1'b0; // default output
        if ((state == S2) && (x == 1'b1))
            z = 1'b1; // sequence "101" detected
    end

endmodule