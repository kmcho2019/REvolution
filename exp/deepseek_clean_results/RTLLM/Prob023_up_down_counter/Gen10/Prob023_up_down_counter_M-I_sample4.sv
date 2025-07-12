module up_down_counter (
    input clk,
    input reset,
    input enable,       // New enable signal
    input up_down,
    output reg [15:0] count
);

reg [15:0] next_count;
reg [15:0] intermediate;

// Shared arithmetic unit
wire [15:0] delta = up_down ? 16'h0001 : 16'hFFFF;

// Pipeline stage 1: Calculate next value
always @(posedge clk) begin
    if (reset) begin
        intermediate <= 16'b0;
    end else if (enable) begin
        intermediate <= count + delta;
    end
end

// Pipeline stage 2: Update output
always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (enable) begin
        count <= intermediate;
    end
end

endmodule