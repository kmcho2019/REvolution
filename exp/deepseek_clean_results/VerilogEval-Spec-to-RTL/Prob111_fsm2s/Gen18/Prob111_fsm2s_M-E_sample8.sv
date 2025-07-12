module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset)
            state_shift <= 2'b00;
        else
            state_shift <= {state_shift[0], state_shift[1] ? ~k : j};
    end

    assign out = state_shift[1];

endmodule