module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;
    reg inversion_bit, next_inversion_bit;

    // State and inversion_bit register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            inversion_bit <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            inversion_bit <= next_inversion_bit;
            // Output register updated on clock edge, depends only on inversion_bit and input
            z <= x ^ inversion_bit;
        end
    end

    // Next state and inversion_bit logic combinational
    always @(*) begin
        case (state)
            COPY: begin
                if (x == 1'b1) begin
                    next_state = INVERT;
                    next_inversion_bit = 1'b1;
                end else begin
                    next_state = COPY;
                    next_inversion_bit = 1'b0;
                end
            end
            INVERT: begin
                next_state = INVERT;
                next_inversion_bit = 1'b1;
            end
            default: begin
                next_state = COPY;
                next_inversion_bit = 1'b0;
            end
        endcase
    end

endmodule