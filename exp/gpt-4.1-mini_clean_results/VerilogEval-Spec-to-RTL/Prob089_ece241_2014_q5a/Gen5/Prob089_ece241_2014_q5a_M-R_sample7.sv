module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;
    reg x_reg;

    // Sequential logic: state and input sampling with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            case (state)
                S0: state <= (x_reg == 1'b1) ? S1 : S0;
                S1: state <= S1;
                default: state <= S0;
            endcase
        end
    end

    // Combinational Moore output logic based on registered inputs and state
    always @(*) begin
        case (state)
            S0: z = x_reg;
            S1: z = ~x_reg;
            default: z = 1'b0;
        endcase
    end

endmodule