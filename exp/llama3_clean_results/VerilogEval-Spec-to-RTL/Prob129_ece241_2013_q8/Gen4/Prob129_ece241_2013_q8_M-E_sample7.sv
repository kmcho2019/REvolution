module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

logic [2:0] seq_reg; // Register to hold the last three input values
logic [1:0] cnt_1;  // Counter for '1's in the sequence
logic [1:0] cnt_0;  // Counter for '0's in the sequence

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        seq_reg <= 3'b000;
        cnt_1 <= 2'b00;
        cnt_0 <= 2'b00;
    end else begin
        // Shift the sequence register to the left
        seq_reg <= {x, seq_reg[2:1]};
        
        // Count '1's and '0's in the sequence
        cnt_1 <= (seq_reg == 3'b101) ? 2'b01 :
                  (seq_reg[2] == 1'b1) ? cnt_1 + 1'b1 :
                  2'b00;
        cnt_0 <= (seq_reg == 3'b101) ? 2'b01 :
                  (seq_reg[1] == 1'b0 && seq_reg[2] == 1'b1) ? cnt_0 + 1'b1 :
                  2'b00;
        
        // Assert output 'z' when the sequence matches "101"
        assign z = (seq_reg == 3'b101);
    end
end

endmodule