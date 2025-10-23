module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

reg [2:0] counter;  // 3-bit counter for 8 positions

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;
        counter <= 3'b0;
    end
    else begin
        q[counter] <= d[counter];  // Update only the current position
        counter <= counter + 1;    // Move to next position
    end
end

endmodule