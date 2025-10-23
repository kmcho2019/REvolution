module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signal to detect clock transitions
reg prev_clk;

// Detect clock transitions to generate enable signal
reg enable;
always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin
        enable <= 1'b1;
    end else begin
        enable <= 1'b0;
    end
    prev_clk <= clk;
end

// Single flip-flop triggered by enable signal
always @(posedge clk) begin
    if (enable) begin
        q <= d;
    end
end

endmodule