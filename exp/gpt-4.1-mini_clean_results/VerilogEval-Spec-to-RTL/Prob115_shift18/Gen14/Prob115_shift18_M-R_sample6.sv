module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Extract control signals
    wire direction = amount[1];   // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];  // 0: shift by 1, 1: shift by 8
    wire [5:0] shift_amt = shift_by_8 ? 6'd8 : 6'd1;

    // Combinational next state logic
    reg [63:0] next_q;

    always @* begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            if (!direction) begin
                // Left shift by shift_amt
                next_q = q << shift_amt;
            end else begin
                // Arithmetic right shift by shift_amt
                // Extend sign bit on left before shifting
                next_q = ({ {63{q[63]}}, q[63] }) >> shift_amt;
            end
        end else begin
            next_q = q; // Hold
        end
    end

    // Sequential logic: update q on clock
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule