module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg started;
reg carry;

always @ (posedge clk or posedge areset) begin
    if(areset) begin
        started <= 1'b0;
        carry <= 1'b0;
        z <= 1'b0;
    end else begin
        if(!started) begin
            if(x) begin
                started <= 1'b1;
                carry <= 1'b0;
                z <= 1'b1;
            end else begin
                started <= 1'b0;
                carry <= 1'b0;
                z <= 1'b0;
            end
        end else begin
            z <= x ^ 1'b1 ^ carry;
            carry <= (x ^ 1'b1) & ~carry;
        end
    end
end

endmodule