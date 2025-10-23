module TopModule(x, y, z);
    input x, y;
    output z;
    reg z_reg;

    always @(*) begin
        if (x == y) begin
            // ModuleB's logic
            z_reg = 1'b1;
        end else if (x == 1'b1 && y == 1'b0) begin
            // ModuleA's logic when x=1 and y=0
            z_reg = 1'b1;
        end else begin
            z_reg = 1'b0;
        end
    end

    assign z = z_reg;
endmodule