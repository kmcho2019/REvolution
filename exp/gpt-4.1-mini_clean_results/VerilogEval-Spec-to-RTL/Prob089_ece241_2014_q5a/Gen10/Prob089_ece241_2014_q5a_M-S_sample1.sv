module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;

    // State register with async reset and state transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else if (state == S0 && x == 1'b1)
            state <= S1;
        else
            state <= state;
    end

    // Moore output logic
    always @(*) begin
        case(state)
            S0: z = x;
            S1: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule