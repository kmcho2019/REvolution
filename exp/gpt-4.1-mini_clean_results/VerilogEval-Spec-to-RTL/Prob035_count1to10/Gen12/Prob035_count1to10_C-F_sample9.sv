module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;
    wire reached_ten = (q == 4'd10);
    wire enable = ~reset; // Enable counting only when not in reset

    always @(*) begin
        if (reset)
            next_q = 4'd1;          // synchronous reset to 1
        else if (reached_ten)
            next_q = 4'd1;          // wrap around after 10
        else if (enable)
            next_q = q + 1'b1;      // increment only when enabled
        else
            next_q = q;             // hold value if not enabled (covers reset case)
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule