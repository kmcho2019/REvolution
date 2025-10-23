module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            // Moore output depends on current input and state
            z <= x ^ state;
            // Update state: stay if already in invert state, else go to invert if x==1
            state <= state | x;
        end
    end

endmodule