module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Combinational shift results
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    reg [63:0] next_q;

    always @(*) begin
        case (amount)
            2'b00: next_q = shift_left_1;
            2'b01: next_q = shift_left_8;
            2'b10: next_q = shift_right_1;
            2'b11: next_q = shift_right_8;
            default: next_q = q; // safe default, though amount is 2 bits
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= next_q;
        end else begin
            q <= q;
        end
    end

endmodule