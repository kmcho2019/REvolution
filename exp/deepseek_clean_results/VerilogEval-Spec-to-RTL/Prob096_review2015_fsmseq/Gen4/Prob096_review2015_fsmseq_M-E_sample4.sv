module TopModule (
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
            // Shift in new data bit
            shift_reg <= {shift_reg[2:0], data};
            
            // Set output if pattern matches and not already set
            if (!start_shifting && shift_reg == 4'b1101) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule