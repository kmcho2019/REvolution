module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire reached_ten;
    wire [3:0] next_q;

    // Use direct equality check for 10 detection to help synthesis optimize
    assign reached_ten = (q == 4'd10);

    // Use conditional operator in continuous assignment for minimal combinational logic
    assign next_q = reached_ten ? 4'd1 : (q + 1'b1);

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;          // Reset to 1 synchronously
        else
            q <= next_q;        // Next state update
    end

endmodule