module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding: COPY=0, INVERT=1
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;
    reg inversion_bit, next_inversion_bit;
    reg x_d;  // registered input x

    // State register with asynchronous active-high reset
    // Also register input x and output z in the same block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            inversion_bit <= 1'b0;
            x_d <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            inversion_bit <= next_inversion_bit;
            x_d <= x;
            z <= x_d ^ inversion_bit;
        end
    end

    // Next state and inversion bit logic (combinational)
    always @(*) begin
        case(state)
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