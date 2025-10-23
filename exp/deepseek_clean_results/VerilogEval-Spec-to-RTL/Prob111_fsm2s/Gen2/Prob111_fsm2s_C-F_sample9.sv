module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Define states with clear names
    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Efficient state transition logic from Example 2
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= (state & ~k) | (~state & j);
        end
    end

    // Clear Moore output assignment from Example 1
    assign out = (state == ON);

endmodule