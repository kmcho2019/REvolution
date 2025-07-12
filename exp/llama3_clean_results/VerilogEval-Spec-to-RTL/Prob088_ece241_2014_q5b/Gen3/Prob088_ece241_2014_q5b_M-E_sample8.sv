module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] count; // Counter to track consecutive 1's

always @(*) begin
    if(count > 0) begin
        z = ~x;
    end else begin
        z = 0;
    end
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        count <= 0; // Reset counter
    end else begin
        if(x) begin
            count <= count + 1; // Increment counter
        end else begin
            count <= 0; // Reset counter
        end
    end
end

endmodule