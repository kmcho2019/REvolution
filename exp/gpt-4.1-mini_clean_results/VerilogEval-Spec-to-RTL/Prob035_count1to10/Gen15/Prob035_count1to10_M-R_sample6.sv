module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Define a wire indicating if the count reached 10 using equality comparison
    wire reached_ten = (q == 4'd10);

    // Next count value assigned using a continuous assignment
    wire [3:0] next_q = reached_ten ? 4'd1 : (q + 4'd1);

    // Sequential logic: synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;      // Reset counter to 1
        else
            q <= next_q;    // Update to next count
    end

endmodule