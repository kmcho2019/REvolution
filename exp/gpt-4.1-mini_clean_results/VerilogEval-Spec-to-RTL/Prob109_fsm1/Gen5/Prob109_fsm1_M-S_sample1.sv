module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else if (state == B)
            state <= (in == 1'b0) ? A : B;
        else // state == A
            state <= (in == 1'b0) ? B : A;
    end

    // Moore output: depends only on current state
    always @(*) begin
        out = state;
    end

endmodule