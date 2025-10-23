module TopModule (
    input clk,
    input aresetn,  // active low async reset
    input x,
    output reg z
);

    // State encoding
    localparam S0 = 2'd0,
               S1 = 2'd1,
               S2 = 2'd2;

    reg [1:0] state, next_state;
    reg next_z;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Output register
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            z <= 1'b0;
        else
            z <= next_z;
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

    // Output logic (Mealy output depends on state and input)
    always @(*) begin
        case (state)
            S2: next_z = (x == 1'b1) ? 1'b1 : 1'b0;
            default: next_z = 1'b0;
        endcase
    end

endmodule