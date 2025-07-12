module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else if (train_valid) begin
        case ({train_taken, state})
            // Increment cases (train_taken = 1)
            3'b100: state <= 2'b01;  // 00 -> 01
            3'b101: state <= 2'b10;  // 01 -> 10
            3'b110: state <= 2'b11;  // 10 -> 11
            3'b111: state <= 2'b11;  // 11 -> 11 (saturate)
            
            // Decrement cases (train_taken = 0)
            3'b000: state <= 2'b00;  // 00 -> 00 (saturate)
            3'b001: state <= 2'b00;  // 01 -> 00
            3'b010: state <= 2'b01;  // 10 -> 01
            3'b011: state <= 2'b10;  // 11 -> 10
        endcase
    end
    // else hold state (implicit)
end

endmodule