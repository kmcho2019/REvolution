module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire signed [1:0] delta = train_valid ? (train_taken ? 2'sb01 : 2'sb11) : 2'sb00;
wire signed [1:0] next_state_signed = $signed(state) + delta;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // reset to weakly not-taken
    end
    else begin
        // Saturating arithmetic
        if (next_state_signed > 2'sd1) begin  // >1 means 2 or 3 in 2-bit signed
            state <= (next_state_signed > 2'sd3) ? 2'b11 : next_state_signed[1:0];
        end
        else begin
            state <= (next_state_signed < 2'sd0) ? 2'b00 : next_state_signed[1:0];
        end
    end
end

endmodule