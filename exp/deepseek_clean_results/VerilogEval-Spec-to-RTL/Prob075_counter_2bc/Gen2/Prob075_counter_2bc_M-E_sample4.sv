module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [2:0] next_state_wide;
wire [1:0] next_state;

// Calculate next state with extra bit for overflow detection
assign next_state_wide = {1'b0, state} + 
                        (train_valid ? (train_taken ? 3'b001 : 3'b111) : 3'b000);

// Apply saturation logic
assign next_state = (next_state_wide[2] & ~train_taken) ? 2'b00 :  // Underflow check
                    (next_state_wide[1:0] == 2'b11 & train_taken) ? 2'b11 : // Overflow check
                    next_state_wide[1:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken state
    end else begin
        state <= next_state;
    end
end

endmodule