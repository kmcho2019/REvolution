module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    reg signed [16:0] delta;

    always @(*) begin
        if (up_down)
            delta = 17'sd1;
        else
            delta = -17'sd1;
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count <= count + delta[15:0];
        end
    end

endmodule