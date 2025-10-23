module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] twos_complement;
reg [31:0] accumulator;
reg [4:0] counter;
reg invert;
reg idle;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        idle <= 1;
        twos_complement <= 32'd0;
        accumulator <= 32'd0;
        counter <= 5'd0;
        invert <= 0;
    end else begin
        if (idle) begin
            if (~areset) begin
                accumulator <= {31'd0, x};
                counter <= 5'd1;
                idle <= 0;
            end
        end else if (~invert) begin
            accumulator <= {accumulator[30:0], x};
            counter <= counter + 1;
            if (areset) begin
                twos_complement <= ~accumulator + 1;
                invert <= 1;
            end
        end else begin
            twos_complement <= twos_complement >> 1;
            if (counter == 5'd0) begin
                idle <= 1;
                invert <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign z = twos_complement[0];

endmodule