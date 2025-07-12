module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] pos;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
        end else begin
            pos <= pos + 3'd1;
        end
    end

    always @(*) begin
        out = 8'b0000_0001 << pos;
    end

endmodule