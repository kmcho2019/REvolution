module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Internal enable for shifting
    wire shift_enable = ena & ~load;

    wire msb = q[63];

    // Compute left shifts gated by shift_enable to reduce toggling
    wire [63:0] shift_left_1  = shift_enable ? {q[62:0], 1'b0} : 64'b0;
    wire [63:0] shift_left_8  = shift_enable ? {q[55:0], 8'b0} : 64'b0;

    // Compute arithmetic right shifts gated by shift_enable
    wire [63:0] shift_right_1 = shift_enable ? {msb, q[63:1]} : 64'b0;
    wire [63:0] shift_right_8 = shift_enable ? {{8{msb}}, q[63:8]} : 64'b0;

    // First stage mux: select shift amount within direction
    wire [63:0] shift_left_sel  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] shift_right_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Second stage mux: select direction
    wire [63:0] shift_val = (amount[1] == 1'b0) ? shift_left_sel : shift_right_sel;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
    end

endmodule