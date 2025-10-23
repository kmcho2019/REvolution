module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg last_d;

// Detect input changes
wire input_changed = (d != last_d);

// Capture data on positive clock edge only when input changes
always @(posedge clk) begin
    last_d <= d;
    if (input_changed) begin
        q_pos <= d;
    end
end

// Capture data on negative clock edge only when input changes
always @(negedge clk) begin
    if (input_changed) begin
        q_neg <= d;
    end
end

// Select appropriate output based on current clock phase
assign q = clk ? q_pos : q_neg;

endmodule