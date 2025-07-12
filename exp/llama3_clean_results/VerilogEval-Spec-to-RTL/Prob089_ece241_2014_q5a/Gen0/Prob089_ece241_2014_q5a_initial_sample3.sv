module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg started;
reg [1:0] carry;

always @ (posedge clk or posedge areset) begin
    if(areset) begin
        started <= 1'b0;
        carry <= 2'b00;
        z <= 1'b0;
    end else begin
        if(!started) begin
            if(x) begin
                started <= 1'b1;
                carry <= 2'b01;
                z <= 1'b1;
            end else begin
                started <= 1'b0;
                carry <= 2'b00;
                z <= 1'b0;
            end
        end else begin
            z <= x ^ 1'b1;
            if(carry[0] == 1'b0) begin
                carry <= {x, 1'b1};
            end else begin
                carry <= {carry[0], x ^ carry[0]};
            end
        end
    end
end

endmodule