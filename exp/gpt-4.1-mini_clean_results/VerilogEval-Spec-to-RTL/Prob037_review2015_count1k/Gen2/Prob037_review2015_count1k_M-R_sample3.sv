module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] next_q;

    // Combinational next state logic
    always @(*) begin
        if (reset) begin
            next_q = 10'd0;
        end else if (q == 10'd999) begin
            next_q = 10'd0;
        end else begin
            next_q = q + 10'd1;
        end
    end

    // Sequential logic updates q at clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule