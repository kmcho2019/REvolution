module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Clock gating logic
wire clk_en = load | ena;
wire gated_clk;
assign gated_clk = clk & clk_en;

// Shift operations with shared logic
wire [63:0] shift_left = (amount[0]) ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
wire [63:0] shift_right = (amount[0]) ? {{8{q[63]}}, q[63:8]} : {q[63], q[63:1]};

// Two-stage mux for better timing
wire [63:0] shifted_val = (amount[1]) ? shift_right : shift_left;
wire [63:0] next_q = (load) ? data : shifted_val;

always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule