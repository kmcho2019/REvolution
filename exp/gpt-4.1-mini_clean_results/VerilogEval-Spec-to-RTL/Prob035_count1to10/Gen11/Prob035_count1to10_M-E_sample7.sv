module TopModule (
    input wire clk,
    input wire reset,
    output reg [3:0] q
);

    // Next value logic
    wire [3:0] q_next;

    // Determine next count value: if q is 10, wrap to 1; else increment by 1
    assign q_next = (q == 4'd10) ? 4'd1 : q + 4'd1;

    // Sequential logic: synchronous active-high reset sets q to 1
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= q_next;
    end

endmodule