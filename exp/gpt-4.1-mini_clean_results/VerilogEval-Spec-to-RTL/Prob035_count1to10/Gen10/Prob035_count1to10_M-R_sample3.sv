module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

    reg [3:0] count;

    // Sequential logic: synchronous reset and count update with wrap-around
    always @(posedge clk) begin
        if (reset)
            count <= 4'd1;
        else
            count <= (count == 4'd10) ? 4'd1 : count + 4'd1;
    end

    // Output directly assigned from count register
    assign q = count;

endmodule