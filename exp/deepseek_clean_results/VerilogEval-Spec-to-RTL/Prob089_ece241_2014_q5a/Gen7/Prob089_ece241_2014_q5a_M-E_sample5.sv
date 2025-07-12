module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Shift register to track inversion point
    reg inv_flag;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            inv_flag <= 1'b0;
        end else begin
            // Propagate the flag once set, or set it when we see first '1'
            inv_flag <= inv_flag | x;
        end
    end
    
    // Output is x when flag is 0, ~x when flag is 1
    assign z = inv_flag ? ~x : x;

endmodule