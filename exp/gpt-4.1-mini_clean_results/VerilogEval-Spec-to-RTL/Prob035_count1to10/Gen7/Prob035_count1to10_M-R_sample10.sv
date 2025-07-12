module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Next state logic
    always @(*) begin
        if (reset)
            next_q = 4'd1;  // synchronous reset sets next value to 1
        else if (q == 4'd10)
            next_q = 4'd1;  // wrap around to 1 after 10
        else
            next_q = q + 4'd1; // increment otherwise
    end

    // Sequential logic
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule