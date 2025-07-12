module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire reached_ten = (q == 4'd10);
    reg [3:0] next_q;

    always @(*) begin
        if (reset)
            next_q = 4'd1;           // synchronous reset to 1
        else if (reached_ten)
            next_q = 4'd1;           // wrap after 10
        else
            next_q = q + 1'b1;       // increment
    end

    // Enable counting only when not reset (to reduce toggling)
    // This reduces switching when reset is active or stable count at 10 before wrap.
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule