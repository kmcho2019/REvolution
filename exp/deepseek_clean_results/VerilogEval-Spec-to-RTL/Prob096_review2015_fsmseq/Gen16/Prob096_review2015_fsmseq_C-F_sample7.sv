module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [2:0] shift_reg;  // Stores last 3 bits
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            found <= 1'b0;
            start_shifting <= 1'b0;
        end else begin
            if (!found) begin
                shift_reg <= {shift_reg[1:0], data};
                found <= ({shift_reg, data} == 4'b1101);
            end
            start_shifting <= found;
        end
    end

endmodule