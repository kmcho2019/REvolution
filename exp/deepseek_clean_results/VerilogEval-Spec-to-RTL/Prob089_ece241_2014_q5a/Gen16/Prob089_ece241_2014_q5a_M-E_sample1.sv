module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg found_one;
    reg [1:0] shift_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            found_one <= 1'b0;
            shift_reg <= 2'b00;
            z <= 1'b0;
        end else begin
            // Update shift register
            shift_reg <= {shift_reg[0], x};
            
            // Update found_one flag
            if (!found_one && x)
                found_one <= 1'b1;
            
            // Determine output
            if (!found_one)
                z <= x;
            else
                z <= ~x;
        end
    end

endmodule