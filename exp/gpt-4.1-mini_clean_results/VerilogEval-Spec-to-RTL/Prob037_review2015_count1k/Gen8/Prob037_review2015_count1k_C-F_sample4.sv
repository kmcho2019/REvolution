module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    wire [10:0] next_val = q + 11'd1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            if (next_val == 11'd1000) begin
                q <= 10'd0;
            end else begin
                q <= next_val[9:0];
            end
        end
    end

endmodule