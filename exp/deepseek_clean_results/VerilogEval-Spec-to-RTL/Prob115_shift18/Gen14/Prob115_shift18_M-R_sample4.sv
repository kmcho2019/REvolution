module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [63:0] next_q;
wire do_shift = ena & ~load;

always @(*) begin
    if (load) begin
        next_q = data;
    end
    else if (do_shift) begin
        case (amount)
            2'b00: next_q = {q[62:0], 1'b0};          // left 1
            2'b01: next_q = {q[55:0], 8'b0};           // left 8
            2'b10: next_q = {q[63], q[63:1]};         // right 1 (arithmetic)
            2'b11: next_q = {{8{q[63]}}, q[63:8]};     // right 8 (arithmetic)
            default: next_q = q;
        endcase
    end
    else begin
        next_q = q;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule