module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Gray-coded state encoding
    localparam [1:0] S0 = 2'b00,
                     S1 = 2'b01,
                     S2 = 2'b11;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic (detect 101 when in S2 and x=1)
    assign z = (state == S2) & x;

endmodule