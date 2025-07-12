module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] w_reg; // Shift register to store 'w' values

always @(posedge clk) begin
    if(reset) begin
        w_reg <= 0;
        z <= 0;
    end
    else begin
        // Shift 'w' value into the shift register
        w_reg <= {w, w_reg[2:1]};
        
        // Check if 'w' is 1 in exactly two of the last three clock cycles
        if (s == 1 || (w_reg[0] + w_reg[1] + w_reg[2]) == 2) begin
            z <= (w_reg[0] + w_reg[1] + w_reg[2]) == 2;
        end else begin
            z <= 0;
        end
    end
end

endmodule