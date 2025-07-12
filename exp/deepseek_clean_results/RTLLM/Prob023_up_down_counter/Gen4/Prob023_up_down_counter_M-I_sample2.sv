module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input enable,      // New enable signal
    input up_down,
    output reg [WIDTH-1:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end
    else if (enable) begin
        count <= up_down ? count + 1'b1 : count - 1'b1;
    end
    // else hold current value
end

endmodule