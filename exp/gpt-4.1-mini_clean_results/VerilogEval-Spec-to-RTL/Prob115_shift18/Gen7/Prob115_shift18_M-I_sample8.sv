module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted;

    always @(*) begin
        if (ena) begin
            case (amount)
                2'b00: shifted = {q[62:0], 1'b0};                   // left shift by 1
                2'b01: shifted = {q[55:0], 8'b0};                   // left shift by 8
                2'b10: shifted = {q[63], q[63:1]};                  // arithmetic right shift by 1
                2'b11: shifted = {{8{q[63]}}, q[63:8]};             // arithmetic right shift by 8
                default: shifted = q;                                // default hold (should not occur)
            endcase
        end else begin
            shifted = q; // no shift
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule