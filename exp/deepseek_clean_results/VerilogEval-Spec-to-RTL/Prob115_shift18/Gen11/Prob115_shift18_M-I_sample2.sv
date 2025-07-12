module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
reg [63:0] shifted_value;
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Optimized shift logic with enable gating
always @(*) begin
    if (do_shift) begin
        if (shift_right) begin
            // Arithmetic right shift with sign extension
            if (shift_8)
                shifted_value = {{8{q[63]}}, q[63:8]};
            else
                shifted_value = {q[63], q[63:1]};
        end
        else begin
            // Left shift
            if (shift_8)
                shifted_value = {q[55:0], 8'b0};
            else
                shifted_value = {q[62:0], 1'b0};
        end
    end
    else begin
        shifted_value = q; // Hold current value when not shifting
    end
end

// Clock-gated update logic
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= shifted_value;
    // else retain value (implicit)
end

endmodule