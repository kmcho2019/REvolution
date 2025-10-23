module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] counter;
reg [31:0] accumulator;
reg [31:0] complement;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 32'd0;
        accumulator <= 32'd0;
        complement <= 32'd0;
        z <= 1'b0;
    end else begin
        if (counter == 32'd0) begin
            accumulator <= {accumulator[30:0], x};
            counter <= counter + 1;
        end else begin
            complement[0] <= ~x;
            for (int i = 1; i < 32; i++) begin
                complement[i] <= ~accumulator[i-1];
            end
            accumulator <= {accumulator[30:0], x};
            z <= complement[31];
        end
    end
end

endmodule