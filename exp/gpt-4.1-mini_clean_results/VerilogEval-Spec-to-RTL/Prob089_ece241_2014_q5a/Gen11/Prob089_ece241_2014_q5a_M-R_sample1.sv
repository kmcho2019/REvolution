module TopModule (
    input  clk,
    input  areset,
    input  x,
    output      z
);

    // State encoding with parameters for clarity
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state;
    reg x_reg;

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case(state)
                COPY:   state <= (x_reg == 1'b1) ? INVERT : COPY;
                INVERT: state <= INVERT;
                default: state <= COPY;
            endcase
        end
    end

    // Input sampling in separate always block for clarity
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
        end
    end

    // Moore output: combinational assignment from registered inputs and state
    assign z = x_reg ^ state;

endmodule