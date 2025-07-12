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
wire do_update = load | ena;

// Pre-compute all shift options
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// Shift selection logic
always @(*) begin
    case ({ena, load, amount})
        4'b1_0_00: next_q = shift_left_1;   // ena=1, load=0, amount=00
        4'b1_0_01: next_q = shift_left_8;   // ena=1, load=0, amount=01
        4'b1_0_10: next_q = shift_right_1;  // ena=1, load=0, amount=10
        4'b1_0_11: next_q = shift_right_8;  // ena=1, load=0, amount=11
        4'b?_1_??: next_q = data;           // load=1 (ena don't care)
        default:   next_q = q;              // no operation
    endcase
end

// Clock-gated update logic
always @(posedge clk) begin
    if (do_update) begin
        q <= next_q;
    end
    // else retain value (implicit)
end

endmodule