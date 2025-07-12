module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] counter; // Assuming 8-bit counter for demonstration
reg [7:0] accumulator;
reg flag;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 8'b0;
        accumulator <= 8'b0;
        flag <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~flag) begin
            if (x) begin
                flag <= 1'b1;
            end
            accumulator <= {accumulator[6:0], 1'b0};
        end else begin
            accumulator <= {accumulator[6:0], ~x};
        end
        counter <= counter + 1'b1;
        if (flag) begin
            z <= accumulator[0];
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule