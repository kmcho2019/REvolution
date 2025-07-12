module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Next state logic
wire [63:0] next_q;
always @(*) begin
    if (load) begin
        next_q = data;
    end
    else if (do_shift) begin
        if (shift_right) begin
            // Arithmetic right shift (sign-extended)
            next_q = shift_8 ? (q >>> 8) : (q >>> 1);
        end
        else begin
            // Left shift
            next_q = shift_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
        end
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