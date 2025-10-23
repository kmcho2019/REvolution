module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state;
    reg [1:0] next_state;
    reg z_reg;

    // Next-state logic with case statement
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output logic with case statement
    always @(*) begin
        case (state)
            S2: z_reg = x;
            default: z_reg = 1'b0;
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    assign z = z_reg;

endmodule