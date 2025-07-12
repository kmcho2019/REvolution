module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] next_q;

    // Combinational logic to determine next counter value
    always @(*) begin
        if (reset) begin
            next_q = 10'd0;
        end else if (q == 10'd999) begin
            next_q = 10'd0;
        end else begin
            next_q = q + 1;
        end
    end

    // Sequential logic to update counter on clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule