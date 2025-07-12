module up_down_counter (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else if (enable) begin
            if (up_down) begin
                count <= count + 16'd1;
            end else begin
                count <= count - 16'd1;
            end
        end
        // else hold count (no change)
    end

endmodule