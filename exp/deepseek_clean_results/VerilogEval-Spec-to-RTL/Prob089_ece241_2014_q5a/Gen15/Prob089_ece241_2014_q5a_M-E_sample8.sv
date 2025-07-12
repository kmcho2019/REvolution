module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert_flag;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            // Update inversion flag (set when first '1' is seen)
            if (!invert_flag && x) begin
                invert_flag <= 1'b1;
            end
            
            // Output logic
            if (invert_flag) begin
                z <= ~x;
            end else begin
                z <= x;
            end
        end
    end

endmodule