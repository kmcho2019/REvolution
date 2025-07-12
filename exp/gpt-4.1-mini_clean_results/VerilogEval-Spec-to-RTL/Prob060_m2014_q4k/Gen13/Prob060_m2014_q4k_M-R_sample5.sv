module DFF (
    input clk,
    input resetn,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    wire [3:0] q;

    // Instantiate 4 DFFs in a chain to implement shift register
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : shift_chain
            if (i == 0) begin
                DFF dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(in),
                    .q(q[i])
                );
            end else begin
                DFF dff_inst (
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