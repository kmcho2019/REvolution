module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 2'd0; // no match
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '10'

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (combinational Mealy)
    always @(*) begin
        z = 1'b0;
        if (state == S2 && x)
            z = 1'b1; // sequence '101' detected
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule