module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // B state
        else
            state <= (state == 1'b0) ? ~in : in; 
            // From B(0): if in=0 -> A(1), else B(0)
            // From A(1): if in=0 -> B(0), else A(1)
    end

    assign out = ~state;  // B=0 => out=1; A=1 => out=0

endmodule