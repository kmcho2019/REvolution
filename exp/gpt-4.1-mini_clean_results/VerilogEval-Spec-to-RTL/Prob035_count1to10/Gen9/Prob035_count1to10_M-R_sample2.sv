module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic to determine next state
    always @(*) begin
        // Detect count == 10 (binary 1010)
        if (q == 4'd10)
            next_q = 4'd1;
        else
            next_q = q + 1'b1;
    end

    // Sequential logic: state update on rising clock edge
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule