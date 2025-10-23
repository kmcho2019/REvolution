module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg prev_z;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        z <= 1'b0;
        prev_z <= 1'b0;
    end else begin
        if(x) begin
            z <= ~prev_z;
        end else begin
            z <= prev_z;
        end
        prev_z <= z;
    end
end

endmodule