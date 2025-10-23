module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] even_phase_count;
reg [15:0] odd_phase_count;
reg next_direction;

// Phase 1 (rising edge): Update even phase and predict next direction
always @(posedge clk) begin
    if (reset) begin
        even_phase_count <= 16'b0;
        next_direction <= 1'b0;
    end else begin
        next_direction <= up_down; // Predict direction for next phase
        if (up_down)
            even_phase_count <= even_phase_count + 1'b1;
        else
            even_phase_count <= even_phase_count - 1'b1;
    end
end

// Phase 2 (falling edge): Update odd phase using predicted direction
always @(negedge clk) begin
    if (reset) begin
        odd_phase_count <= 16'b0;
    end else begin
        if (next_direction)
            odd_phase_count <= odd_phase_count + 1'b1;
        else
            odd_phase_count <= odd_phase_count - 1'b1;
    end
end

// Combine phases for final output
always @(*) begin
    count = up_down ? 
            (even_phase_count > odd_phase_count ? even_phase_count : odd_phase_count) :
            (even_phase_count < odd_phase_count ? even_phase_count : odd_phase_count);
end

endmodule