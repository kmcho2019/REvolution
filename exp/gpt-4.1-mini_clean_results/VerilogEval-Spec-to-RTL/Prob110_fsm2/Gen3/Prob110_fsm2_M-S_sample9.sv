module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;          // OFF state
        else
            state <= state ? ~k : j; // If ON, next = ~k; If OFF, next = j
    end

    always @(*) out = state;

endmodule