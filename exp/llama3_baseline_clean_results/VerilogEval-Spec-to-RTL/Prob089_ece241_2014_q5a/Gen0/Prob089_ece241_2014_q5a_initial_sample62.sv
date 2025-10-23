module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg seen_one;  // Flag to track if we've seen the first '1'
reg z_out;     // Output buffer

always @(posedge clk or posedge areset) begin
    if (areset) begin
        seen_one <= 1'b0;
        z_out <= 1'b0;
    end else begin
        if (seen_one) begin
            z_out <= ~x;  // Invert bits after first '1'
        end else begin
            if (x) begin
                seen_one <= 1'b1;
                z_out <= ~x;  // Invert the first '1'
            end
        end
    end
end

assign z = z_out;

endmodule