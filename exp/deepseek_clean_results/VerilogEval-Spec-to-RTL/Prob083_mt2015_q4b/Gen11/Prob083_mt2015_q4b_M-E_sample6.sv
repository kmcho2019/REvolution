module TopModule (
    input x,
    input y,
    output reg z
);
    reg prev_equal;
    
    always @(*) begin
        if (x == y) begin
            z = 1'b1;
            prev_equal = 1'b1;
        end else begin
            if (prev_equal) begin
                z = 1'b1;  // Hold for one cycle
                prev_equal = 1'b0;
            end else begin
                z = 1'b0;
            end
        end
    end
endmodule