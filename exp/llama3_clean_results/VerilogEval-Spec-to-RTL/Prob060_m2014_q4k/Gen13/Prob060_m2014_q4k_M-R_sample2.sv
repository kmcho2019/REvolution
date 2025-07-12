// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Parameterized TopModule with Shift Register
module TopModule #(
    parameter STAGES = 4
)(
    input clk,
    input resetn,
    input in,
    output reg out
);

wire [STAGES-2:0] q;

generate
    for (genvar i = 0; i < STAGES; i++) begin
        if (i == 0) begin
            DFF dff0(clk, resetn, in, q[0]);
        end else if (i == STAGES - 1) begin
            DFF dffn(clk, resetn, q[i-1], out);
        end else begin
            DFF dffi(clk, resetn, q[i-1], q[i]);
        end
    end
endgenerate

endmodule