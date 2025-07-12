module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic for next state
    always @(*) begin
        if (reset) begin
            next_q = 4'd1;
        end else if (q == 4'd10) begin
            next_q = 4'd1;
        end else begin
            next_q = q + 4'd1;
        end
    end

    // Sequential update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule