module TopModule (
    input  clk,
    input  in,
    output out
);

    reg q;
    wire next_state;

    assign next_state = in ^ q;
    assign out = q;

    always @(posedge clk) begin
        q <= next_state;
    end

endmodule