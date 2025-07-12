module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

// Clock gating only when counter would wrap
wire count_enable = ~reset & ((up_down & ~(&count)) || (~up_down & |count));

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else if (count_enable) begin
        if (up_down) begin
            count <= count + 1'b1;
        end else begin
            count <= count - 1'b1;
        end
    end
end

endmodule