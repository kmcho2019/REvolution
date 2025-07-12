module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            start_shifting <= 1'b0;
        end else begin
            // Shift in new data from right
            shift_reg <= {shift_reg[2:0], data};
            
            // Set output when pattern matches and keep it set
            if (shift_reg == 4'b1101 || start_shifting) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule