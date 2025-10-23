module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg flip;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            flip <= 1'b0;
        end else begin
            if (!flip && x) begin
                flip <= 1'b1;
            end
        end
    end

    assign z = x ^ flip;

endmodule