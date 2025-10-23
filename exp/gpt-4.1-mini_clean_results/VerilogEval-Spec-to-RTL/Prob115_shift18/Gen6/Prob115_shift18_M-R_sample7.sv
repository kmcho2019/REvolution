module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: next_q = {q[62:0], 1'b0};               // shift left by 1
                2'b01: next_q = {q[55:0], 8'b0};               // shift left by 8
                2'b10: next_q = {q[63], q[63:1]};              // arithmetic shift right by 1
                2'b11: next_q = {{8{q[63]}}, q[63:8]};         // arithmetic shift right by 8
                default: next_q = q;                            // default hold (should never happen)
            endcase
        end else begin
            next_q = q; // hold current value
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule