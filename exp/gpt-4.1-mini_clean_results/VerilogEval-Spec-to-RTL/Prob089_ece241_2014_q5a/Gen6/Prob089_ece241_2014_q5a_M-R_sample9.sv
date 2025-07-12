module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state encoding
    localparam S0 = 2'b01; // Waiting for first '1'
    localparam S1 = 2'b10; // Inverting subsequent bits

    reg [1:0] state, state_next;
    reg x_reg;
    wire clk_en = ~areset;

    // Input sampling with clock enable (gated by reset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else if (clk_en)
            x_reg <= x;
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else if (clk_en)
            state <= state_next;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: state_next = (x_reg == 1'b1) ? S1 : S0;
            S1: state_next = S1;
            default: state_next = S0;
        endcase
    end

    // Moore output logic as continuous assignment
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule