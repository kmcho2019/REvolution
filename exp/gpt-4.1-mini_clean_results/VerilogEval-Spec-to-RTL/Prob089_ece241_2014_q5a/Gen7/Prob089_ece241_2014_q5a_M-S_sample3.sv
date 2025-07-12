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

    // State register with asynchronous reset and output register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= x ^ state;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            COPY: next_state = (x == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

endmodule