module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

wire enable;
assign enable = ~reset;  // Enable counting only when not resetting

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (enable) begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count + 16'hFFFF; // Adding -1 in two's complement
        end
    end
end

endmodule