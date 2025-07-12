module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 1'b0; // waiting for first '1' bit (carry not started)
    localparam S1 = 1'b1; // inverting subsequent bits (carry started)

    reg state;
    reg x_reg;

    // Sequential logic: asynchronous reset, input register, and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            case (state)
                S0: state <= (x_reg) ? S1 : S0;
                S1: state <= S1;
                default: state <= S0;
            endcase
        end
    end

    // Moore output logic: purely combinational from registered input and state
    always @(*) begin
        case (state)
            S0: z = x_reg;       // Output the registered input directly until first '1'
            S1: z = ~x_reg;      // Output inverted registered input bits after first '1'
            default: z = 1'b0;
        endcase
    end

endmodule