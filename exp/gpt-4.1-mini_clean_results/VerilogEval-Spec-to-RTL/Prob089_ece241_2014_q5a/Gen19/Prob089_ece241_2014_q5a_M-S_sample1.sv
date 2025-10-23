module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= state | x;
    end

    assign z = x ^ state;

endmodule