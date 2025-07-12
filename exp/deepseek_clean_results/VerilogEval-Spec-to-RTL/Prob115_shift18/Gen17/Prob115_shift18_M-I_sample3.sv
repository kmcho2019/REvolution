module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
reg [63:0] next_q;
wire do_shift = ena & ~load;

// Shift computation (only when enabled)
always @(*) begin
    if (do_shift) begin
        case (amount)
            2'b00: next_q = {q[62:0], 1'b0};        // Left by 1
            2'b01: next_q = {q[55:0], 8'b0};         // Left by 8
            2'b10: next_q = {q[63], q[63:1]};        // Right by 1 (arithmetic)
            2'b11: next_q = {{8{q[63]}}, q[63:8]};   // Right by 8 (arithmetic)
        endcase
    end
    else begin
        next_q = q; // Hold value when not shifting
    end
end

// Clock-gated register update
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= next_q;
end

endmodule