module DFF_SR (
    input  wire clk,
    input  wire resetn,  // active-low synchronous reset
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);
    wire [3:0] q;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : shift_chain
            if (i == 0) begin
                DFF_SR dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(in),
                    .q(q[i])
                );
            end else begin
                DFF_SR dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(q[i-1]),
                    .q(q[i])
                );
            end
        end
    endgenerate

    assign out = q[3];
endmodule