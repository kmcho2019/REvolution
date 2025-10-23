module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            if (count < 16'hFFFF) begin
                count <= count + 16'd1;
            end else begin
                count <= 16'hFFFF; // Saturate at max value
            end
        end else begin
            if (count > 16'd0) begin
                count <= count - 16'd1;
            end else begin
                count <= 16'd0; // Saturate at zero
            end
        end
    end
end

endmodule