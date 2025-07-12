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
wire [1:0] shift_sel = {amount[1], do_shift};

// Shift operations
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

// Next state logic with optimized mux structure
reg [63:0] next_q;
always @(*) begin
    case (shift_sel)
        2'b00: next_q = q;                     // No shift
        2'b01: next_q = amount[0] ? left_shift_8 : left_shift_1;
        2'b10: next_q = q;                     // Right shift but no ena
        2'b11: next_q = amount[0] ? right_shift_8 : right_shift_1;
    endcase
    
    if (load) next_q = data;                    // Load has highest priority
end

// Clock-gated register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule