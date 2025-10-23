module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = 2'b01;
    end
    else if (train_valid) begin
        // Compute potential next states in parallel
        wire [1:0] inc_state = state + 1'b1;
        wire [1:0] dec_state = state - 1'b1;
        
        // Apply saturation and selection
        next_state = train_taken ? (|state[1:0] ? inc_state : state)  // Saturate at 3 (11)
                                : (state ? dec_state : state);       // Saturate at 0 (00)
    end
    else begin
        next_state = state;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end
    else begin
        state <= next_state;
    end
end

endmodule