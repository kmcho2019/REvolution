module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding using localparam
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy output)
    always @(*) begin
        // Default output
        z = 1'b0;
        if (state == S2 && x == 1'b1)
            z = 1'b1;  // Detect sequence "101"
    end

endmodule