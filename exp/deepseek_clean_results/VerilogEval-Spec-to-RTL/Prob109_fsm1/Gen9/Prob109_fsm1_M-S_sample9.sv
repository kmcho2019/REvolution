module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;
        else
            state <= state ? in : ~in;
    end

    assign out = state;

endmodule