module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding: COPY=0, INVERT=1
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state;           // FSM state
    reg inversion_bit;   // Moore output bit stored in register

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            inversion_bit <= 1'b0;  // output = 0 in COPY state
            z <= 1'b0;
        end else begin
            // State update
            if (state == COPY && x == 1'b1) begin
                state <= INVERT;
                inversion_bit <= 1'b1;
            end else begin
                state <= state;
                inversion_bit <= inversion_bit;
            end

            // Moore output z depends only on registered state (inversion_bit) and input x:
            // z = x ^ inversion_bit
            z <= x ^ inversion_bit;
        end
    end

endmodule