module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Arithmetic-based saturating counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else if (train_valid) begin
        // Combine train_taken into direction (-1 or +1)
        case ({train_taken, state})
            // Decrement cases (train_taken = 0)
            3'b000: state <= 2'b00;  // Already at min (0)
            3'b001: state <= 2'b00;
            3'b010: state <= 2'b01;
            3'b011: state <= 2'b10;
            
            // Increment cases (train_taken = 1)
            3'b100: state <= 2'b01;
            3'b101: state <= 2'b10;
            3'b110: state <= 2'b11;
            3'b111: state <= 2'b11;  // Already at max (3)
        endcase
    end
    // else keep current state
end

endmodule