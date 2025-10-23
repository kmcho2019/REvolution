module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @ (posedge clk) begin
    if (reset) begin
        count <= 0;
    end else begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule