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
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Shift computation (gated by ena)
always @(*) begin
    if (do_shift) begin
        if (shift_right) begin
            // Arithmetic right shift
            if (shift_8)
                next_q = {{8{q[63]}}, q[63:8]}; // Shift right by 8
            else
                next_q = {q[63], q[63:1]};      // Shift right by 1
        end
        else begin
            // Left shift
            if (shift_8)
                next_q = {q[55:0], 8'b0};       // Shift left by 8
            else
                next_q = {q[62:0], 1'b0};       // Shift left by 1
        end
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