module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] next_q;
    wire dir_right = amount[1];
    wire shift_8 = amount[0];
    wire msb = q[63];

    // Sign-extended right shifts helper signals
    wire [63:0] arith_right_1 = {msb, q[63:1]};
    wire [63:0] arith_right_8 = {{8{msb}}, q[63:8]};

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            if (dir_right) begin
                case (shift_8)
                    1'b0: next_q = arith_right_1;
                    1'b1: next_q = arith_right_8;
                endcase
            end else begin
                // Left shifts fill with zeros
                case (shift_8)
                    1'b0: next_q = {q[62:0], 1'b0};
                    1'b1: next_q = {q[55:0], 8'b0};
                endcase
            end
        end else begin
            next_q = q; // hold
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule