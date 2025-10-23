module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Sequential logic to update previous sensor state
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Store previous sensor state
        prev_s <= s;
    end
end

// Combinational logic to determine level signals
wire level_above_high;
assign level_above_high = (s[2] == 1'b1);
wire level_above_middle;
assign level_above_middle = (s[1] == 1'b1) && (!level_above_high);
wire level_above_low;
assign level_above_low = (s[0] == 1'b1) && (!(level_above_high || level_above_middle));

// Combinational logic to determine output signals (fr2, fr1, fr0)
always @(*) begin
    if (level_above_high) begin
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b0;
    end else if (level_above_middle) begin
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b1;
    end else if (level_above_low) begin
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end
end

// Combinational logic to determine supplemental flow rate (dfr) signal
always @(*) begin
    if ((s > prev_s) && (s != 3'b000)) begin
        dfr <= 1'b1;
    end else begin
        dfr <= 1'b0;
    end
end

endmodule