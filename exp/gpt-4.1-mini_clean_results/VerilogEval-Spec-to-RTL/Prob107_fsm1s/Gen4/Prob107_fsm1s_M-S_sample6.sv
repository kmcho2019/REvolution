module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    localparam B = 1'b0, A = 1'b1;
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= (state == B) ? (in ? B : A) : (in ? A : B);
        out <= (state == B);
    end

endmodule