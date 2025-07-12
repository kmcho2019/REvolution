module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: COPY=0, INVERT=1
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;
    reg inversion_bit, next_inversion_bit;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            inversion_bit <= 1'b0;  // no inversion in COPY state
        end else begin
            state <= next_state;
            inversion_bit <= next_inversion_bit;
        end
    end

    // Next state and inversion bit logic
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

    // Moore output: output depends only on registered state (inversion_bit)
    // z = x XOR inversion_bit, combinational output derived from registered state and input
    assign z = x ^ inversion_bit;

endmodule