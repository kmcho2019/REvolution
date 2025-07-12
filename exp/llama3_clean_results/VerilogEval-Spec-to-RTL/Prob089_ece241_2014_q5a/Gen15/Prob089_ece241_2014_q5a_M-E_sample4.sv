module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] counter; // Counter to track the number of bits received
reg selector; // Selector to choose between original and inverted input

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 8'b0;
        selector <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~selector) begin
            if (x) begin
                selector <= 1'b1;
            end
            z <= x;
            counter <= counter + 1'b1;
        end else begin
            z <= ~x;
        end
    end
end

endmodule