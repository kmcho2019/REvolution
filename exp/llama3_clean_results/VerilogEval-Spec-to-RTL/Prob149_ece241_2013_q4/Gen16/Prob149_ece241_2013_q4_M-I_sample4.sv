module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output wire fr2,
    output wire fr1,
    output wire fr0,
    output wire dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Sequential logic to update previous sensor state and reset logic
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

// Reset logic for outputs (synchronous reset)
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end
end

// Continuous assignments for output signals
assign fr2 = ~s[0] && ~s[1] && ~s[2];
assign fr1 = ~s[0] && ~s[1];
assign fr0 = ~s[2];
assign dfr = ((s[0] > prev_s[0]) || (s[1] > prev_s[1] && s[0] == prev_s[0]) || (s[2] > prev_s[2] && s[1] == prev_s[1] && s[0] == prev_s[0])) && (s != 3'b000);

endmodule