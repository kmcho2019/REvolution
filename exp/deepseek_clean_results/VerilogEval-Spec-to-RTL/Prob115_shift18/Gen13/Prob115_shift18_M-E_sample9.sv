module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire shift_left = ~amount[1];
wire shift_1bit = ~amount[0];
wire shift_right_8 = (amount == 2'b11);
wire shift_right_1 = (amount == 2'b10);
wire shift_left_8 = (amount == 2'b01);
wire shift_left_1 = (amount == 2'b00);

// Shift computation (only when enabled)
reg [63:0] next_q;
always @(*) begin
    if (load) begin
        next_q = data;
    end
    else if (ena) begin
        case (amount)
            2'b00: next_q = {q[62:0], 1'b0};                   // Left 1
            2'b01: next_q = {q[55:0], 8'b0};                    // Left 8
            2'b10: next_q = {q[63], q[63:1]};                   // Right 1 (arithmetic)
            2'b11: next_q = {{8{q[63]}}, q[63:8]};              // Right 8 (arithmetic)
            default: next_q = q;
        endcase
    end
    else begin
        next_q = q;
    end
end

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule