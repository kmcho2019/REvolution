module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] w_shift_reg; // 3-bit shift register to track 'w' occurrences
reg start; // Start flag to track when to evaluate 'z'

// Sequential logic for shift register and start flag
always @(posedge clk) begin
    if(reset) begin
        w_shift_reg <= 3'b000;
        start <= 1'b0;
        z <= 1'b0; // Reset output z
    end else begin
        if (~s) begin
            w_shift_reg <= 3'b000;
            start <= 1'b0;
        end else if (~start) begin
            w_shift_reg <= {w, 2'b00};
            start <= 1'b1;
        end else begin
            w_shift_reg <= {w, w_shift_reg[1:0]};
            if (w_shift_reg[2] == 1'b1) begin
                start <= 1'b0;
            end
        end
        
        // Evaluate output 'z' based on the shift register's output
        if (start == 1'b0 && w_shift_reg[2] == 1'b0) begin
            if(w_shift_reg == 3'b110 || w_shift_reg == 3'b101 || w_shift_reg == 3'b011) begin
                z <= 1'b1; // Set 'z' high if 'w' occurred exactly twice in the previous window
            end else begin
                z <= 1'b0;
            end
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule