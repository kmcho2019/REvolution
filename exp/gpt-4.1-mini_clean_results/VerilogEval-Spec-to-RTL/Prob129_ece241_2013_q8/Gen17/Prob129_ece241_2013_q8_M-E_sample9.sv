module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding for three states:
    localparam S0 = 2'b00; // waiting for '1'
    localparam S1 = 2'b01; // got '1', waiting for '0'
    localparam S2 = 2'b10; // got "10", waiting for '1' to complete "101"

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: 
                next_state = x ? S1 : S0;
            S1: 
                next_state = x ? S1 : S2;
            S2: 
                next_state = x ? S1 : S0;
            default: 
                next_state = S0;
        endcase
    end

    // Output logic (Mealy output depends on current state and input)
    always @(*) begin
        if (state == S2 && x == 1'b1)
            z = 1'b1;
        else
            z = 1'b0;
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule