module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg seen_one; // Flag to indicate if a '1' has been seen
reg output_one; // Flag to indicate if we should output '1'

always @(posedge clk or posedge areset) begin
    if(areset) begin
        seen_one <= 0;
        output_one <= 0;
        z <= 0;
    end else begin
        if(!seen_one) begin
            if(x) begin
                seen_one <= 1;
                z <= ~x;
            end else begin
                z <= ~x;
            end
        end else begin
            z <= 1;
        end
    end
end

endmodule