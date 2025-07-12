module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= (state == B) ? (in ? B : A) : (in ? A : B);
    end

    // Moore output directly from state
    always @(posedge clk) begin
        out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule