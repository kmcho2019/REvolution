module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Precompute all shift variants
    wire [63:0] left1  = {q[62:0], 1'b0};
    wire [63:0] left8  = {q[55:0], 8'b0};
    wire [63:0] right1 = {msb, q[63:1]};       // arithmetic right shift by 1
    wire [63:0] right8 = {{8{msb}}, q[63:8]}; // arithmetic right shift by 8

    reg [63:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: next_q = left1;
                2'b01: next_q = left8;
                2'b10: next_q = right1;
                2'b11: next_q = right8;
                default: next_q = q;
            endcase
        end else begin
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule