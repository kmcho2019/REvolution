module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            // Update state: if in COPY and input x=1, transition to INVERT
            if (state == COPY && x)
                state <= INVERT;

            // Output depends only on state (Moore)
            z <= (state == COPY) ? x : ~x;
        end
    end

endmodule