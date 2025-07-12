module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] accumulator; // Assuming a maximum of 32 bits for the input sequence
reg detector;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        accumulator <= 32'b0;
        detector <= 1'b0;
        z <= 1'b0;
    end else begin
        if (!detector) begin
            if (x) begin
                detector <= 1'b1;
            end
            accumulator <= {accumulator[30:0], x};
            z <= x;
        end else begin
            accumulator <= {accumulator[30:0], ~x};
            z <= ~x;
        end
    end
end

endmodule