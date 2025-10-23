module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detector;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 0;
        z <= 0;
    end else if (!detector) begin
        // Directly update z based on x when detector is 0
        z <= x;
        // Set detector to 1 when the first '1' is encountered in the input sequence
        detector <= x;
    end else begin
        // Once detector is 1, invert subsequent bits for 2's complement
        z <= ~x;
    end
end

endmodule