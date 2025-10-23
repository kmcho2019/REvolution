module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            case (state)
                S0: state <= (x == 1'b1) ? S1 : S0;
                S1: state <= S1;
                default: state <= S0;
            endcase
    end

    // Moore output depends only on state and current input x
    always @(*) begin
        case (state)
            S0: z = x;
            S1: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule