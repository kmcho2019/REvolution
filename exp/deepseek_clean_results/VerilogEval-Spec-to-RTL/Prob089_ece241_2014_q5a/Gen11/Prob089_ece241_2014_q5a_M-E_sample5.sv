module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg invert_flag;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 1'b0;
        end else begin
            if (!invert_flag && x) begin
                invert_flag <= 1'b1;
            end
        end
    end
    
    assign z = invert_flag ? ~x : x;

endmodule