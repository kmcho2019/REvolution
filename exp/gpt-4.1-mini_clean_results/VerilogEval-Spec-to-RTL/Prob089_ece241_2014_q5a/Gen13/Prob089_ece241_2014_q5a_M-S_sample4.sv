module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: 0 = COPY, 1 = INVERT
    reg state;
    reg inversion_bit;

    // State and inversion_bit update with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;          // COPY state
            inversion_bit <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // COPY state
                    if (x) begin
                        state <= 1'b1;      // Move to INVERT state
                        inversion_bit <= 1'b1;
                    end else begin
                        state <= 1'b0;      // Stay in COPY
                        inversion_bit <= 1'b0;
                    end
                end
                1'b1: begin // INVERT state
                    state <= 1'b1;          // Stay in INVERT
                    inversion_bit <= 1'b1;
                end
            endcase
        end
    end

    // Output z depends on current input and inversion_bit (Moore machine output with input combinationally)
    assign z = x ^ inversion_bit;

endmodule