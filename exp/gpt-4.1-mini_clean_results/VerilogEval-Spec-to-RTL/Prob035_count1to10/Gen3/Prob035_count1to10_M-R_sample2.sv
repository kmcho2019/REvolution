module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic to determine next counter value
    always @(*) begin
        if (q == 4'd10) begin
            next_q = 4'd1;
        end else begin
            next_q = q + 4'd1;
        end
    end

    // Sequential logic to update q on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;
        end else begin
            q <= next_q;
        end
    end

endmodule