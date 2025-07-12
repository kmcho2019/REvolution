module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;
    reg x_reg;
    reg inversion_bit, next_inversion_bit;

    // Sequential logic: state, inversion_bit and input sampling with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state         <= COPY;
            inversion_bit <= 1'b0;
            x_reg         <= 1'b0;
            z             <= 1'b0;
        end else begin
            state         <= next_state;
            inversion_bit <= next_inversion_bit;
            x_reg         <= x;
            // Moore output: output depends only on registered inversion_bit and registered input x_reg
            z             <= x_reg ^ inversion_bit;
        end
    end

    // Combinational logic for next state and next inversion_bit
    always @(*) begin
        case (state)
            COPY: begin
                if (x_reg == 1'b1) begin
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