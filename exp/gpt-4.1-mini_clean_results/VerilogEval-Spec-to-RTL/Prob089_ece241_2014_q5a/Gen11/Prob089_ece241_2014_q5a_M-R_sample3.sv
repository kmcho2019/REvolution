module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: COPY=0, INVERT=1
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state;
    reg inversion_bit;

    // State and inversion bit registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            inversion_bit <= 1'b0;
        end else begin
            case (state)
                COPY: begin
                    if (x == 1'b1) begin
                        state <= INVERT;
                        inversion_bit <= 1'b1;
                    end else begin
                        state <= COPY;
                        inversion_bit <= 1'b0;
                    end
                end
                INVERT: begin
                    state <= INVERT;
                    inversion_bit <= 1'b1;
                end
                default: begin
                    state <= COPY;
                    inversion_bit <= 1'b0;
                end
            endcase
        end
    end

    // Output combinational logic: Moore output depends only on state (inversion_bit)
    // Output z is x XOR inversion_bit
    assign z = x ^ inversion_bit;

endmodule