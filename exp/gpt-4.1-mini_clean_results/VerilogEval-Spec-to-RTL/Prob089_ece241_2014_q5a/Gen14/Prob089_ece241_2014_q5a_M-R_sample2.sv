module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam S0 = 1'b0; // waiting for first '1' bit (carry not started)
    localparam S1 = 1'b1; // inverting subsequent bits (carry started)

    reg state;
    reg x_reg;

    // Register input synchronously
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else begin
            case (state)
                S0: state <= (x_reg) ? S1 : S0;
                S1: state <= S1;
                default: state <= S0;
            endcase
        end
    end

    // Moore output logic as continuous assignment
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule