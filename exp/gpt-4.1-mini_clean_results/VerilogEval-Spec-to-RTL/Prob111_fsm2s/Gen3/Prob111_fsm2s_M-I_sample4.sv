module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Next state combinational logic simplified with if-else
    always @(*) begin
        if (state == OFF) begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
        end else begin // state == ON
            if (k)
                next_state = OFF;
            else
                next_state = ON;
        end
    end

    // Sequential logic: state register and registered Moore output
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            // Output depends on state after state update (Moore output)
            out <= (next_state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule