module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0; // Corresponds to q=1
            q <= 4'd1;
        end else begin
            if (count == 4'd9) begin
                count <= 4'd0;
                q <= 4'd1;
            end else begin
                count <= count + 1'b1;
                q <= count + 1'b1;
            end
        end
    end

endmodule