module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state, next_state;
    reg x_reg;  // Registered input bit

    // State register and input register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (x_reg == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // Moore output logic, depends only on registered input and state
    always @(*) begin
        case (state)
            S0: z = x_reg;      // Output input bit directly
            S1: z = ~x_reg;     // Output inverted input bit
            default: z = 1'b0;
        endcase
    end

endmodule