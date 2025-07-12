module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating signals
wire rotate_en = |ena;  // Enable when rotating (ena=01 or 10)
wire clk_en = load | rotate_en;
wire gated_clk = clk & clk_en;

// Rotation logic
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};
wire [99:0] rotated_data = (ena[1]) ? left_rot : right_rot;

// Next state logic
always @(*) begin
    if (load) begin
        q = data;
    end else if (rotate_en) begin
        q = rotated_data;
    end
    // else hold current value (implicit)
end

// Synchronous update with clock gating
always @(posedge gated_clk or posedge clk) begin
    if (clk) begin
        // Only update if clock is enabled or we have a load
        if (clk_en) begin
            q <= (load) ? data : rotated_data;
        end
    end
end

endmodule