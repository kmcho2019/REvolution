module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    reg [63:0] next_q;

    // Combinational logic for next_q
    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: next_q = q << 1;
                2'b01: next_q = q << 8;
                2'b10: next_q = {q[63], q[63:1]};           // arithmetic right shift by 1
                2'b11: next_q = {{8{q[63]}}, q[63:8]};      // arithmetic right shift by 8
                default: next_q = q; // default case (should not occur)
            endcase
        end else begin
            next_q = q;
        end
    end

    // Sequential update of q
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule