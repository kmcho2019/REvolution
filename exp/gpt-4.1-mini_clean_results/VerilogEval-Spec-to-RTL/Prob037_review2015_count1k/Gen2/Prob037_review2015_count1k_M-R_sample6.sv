module TopModule #(
    parameter MAX_COUNT = 10'd999
)(
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] next_q;

    // Combinational logic to determine next state
    always @(*) begin
        if (reset) begin
            next_q = 10'd0;
        end else if (q >= MAX_COUNT) begin
            next_q = 10'd0;
        end else begin
            next_q = q + 10'd1;
        end
    end

    // Sequential logic to update q
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule