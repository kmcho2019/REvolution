module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the desired sequence as a binary literal
localparam DESIRED_SEQ = 5'b10011;

// Initialize the shift register
reg [4:0] shift_reg;

// Pipeline the logic to reduce the critical path length
reg [4:0] next_shift_reg;

// Clock enable signal for clock gating
reg clk_enable;

// Update the shift register and the MATCH signal
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the shift register and the MATCH signal
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
        clk_enable <= 1'b0;
    end else begin
        // Update the clock enable signal
        if (shift_reg == DESIRED_SEQ) begin
            clk_enable <= 1'b0;
        end else begin
            clk_enable <= 1'b1;
        end
        
        // Update the shift register
        if (clk_enable) begin
            next_shift_reg <= {IN, shift_reg[4:1]};
        end else begin
            next_shift_reg <= shift_reg;
        end
        
        // Update the shift register
        shift_reg <= next_shift_reg;
        
        // Check if the shift register matches the desired sequence
        if (shift_reg == DESIRED_SEQ) begin
            // Assert the MATCH signal
            MATCH <= 1'b1;
        end else begin
            // Deassert the MATCH signal
            MATCH <= 1'b0;
        end
    end
end

endmodule