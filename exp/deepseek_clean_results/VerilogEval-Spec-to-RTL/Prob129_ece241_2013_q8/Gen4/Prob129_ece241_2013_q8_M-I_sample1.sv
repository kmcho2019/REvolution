module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] shift_reg;  // Stores previous two bits
    reg x_prev;           // Previous x value for enable condition

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 2'b00;
            x_prev <= 1'b0;
            z <= 1'b0;
        end else begin
            // Only update shift register when x changes to save power
            if (x != x_prev) begin
                shift_reg <= {shift_reg[0], x};
                x_prev <= x;
            end
            
            // Registered Mealy output
            z <= (shift_reg == 2'b10) && x;
        end
    end

endmodule