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

    // Sequential logic: asynchronous reset, input and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            if (state == S0) begin
                if (x_reg) 
                    state <= S1;
            end
            // If in S1, remain in S1
        end
    end

    // Moore output logic: assigned combinationally from registered signals
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule