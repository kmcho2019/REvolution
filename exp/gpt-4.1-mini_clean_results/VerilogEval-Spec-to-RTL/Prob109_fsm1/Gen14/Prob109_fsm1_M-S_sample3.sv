module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam B = 1'b1;
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= (state == B) ? (in ? B : 1'b0) : (in ? 1'b0 : B);
    end

    assign out = state;

endmodule