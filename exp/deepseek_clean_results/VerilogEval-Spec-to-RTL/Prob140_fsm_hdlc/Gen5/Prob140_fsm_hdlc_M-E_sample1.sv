module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;
    wire discard_condition = (shift_reg == 7'b0111110);
    wire flag_condition = (shift_reg == 7'b0111111);
    wire error_condition = (shift_reg == 7'b1111111);

    // Shift register to maintain history
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
        end
    end

    // Output generation with one-cycle delay
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Clear outputs after one cycle
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
            
            // Set outputs based on detected patterns
            if (discard_condition) disc <= 1'b1;
            if (flag_condition) flag <= 1'b1;
            if (error_condition) err <= 1'b1;
        end
    end

endmodule