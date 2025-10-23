module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: COPY = 0, INVERT = 1 (one bit)
    logic state;
    logic inversion_bit;
    logic x_reg;

    // Synchronize input x
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State and inversion_bit registers with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;          // COPY state
            inversion_bit <= 1'b0;
        end else begin
            // Next state logic
            // From COPY: if x_reg=1 go to INVERT, else stay in COPY
            // From INVERT: stay in INVERT
            if (state == 1'b0) begin
                if (x_reg) begin
                    state <= 1'b1;       // INVERT
                    inversion_bit <= 1'b1;
                end else begin
                    state <= 1'b0;       // COPY
                    inversion_bit <= 1'b0;
                end
            end else begin
                // INVERT state
                state <= 1'b1;
                inversion_bit <= 1'b1;
            end
        end
    end

    // Output depends only on registered input and inversion bit (Moore FSM output)
    assign z = x_reg ^ inversion_bit;

endmodule