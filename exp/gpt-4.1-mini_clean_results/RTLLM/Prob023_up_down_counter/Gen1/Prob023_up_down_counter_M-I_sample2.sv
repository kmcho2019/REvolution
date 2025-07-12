module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire signed [15:0] increment;
    assign increment = up_down ? 16'sd1 : -16'sd1;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count <= count + increment;
        end
    end

endmodule