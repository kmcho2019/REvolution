module DFF (
    input clk,
    input resetn,
    input enable,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= 1'b0;
        end else if (enable) begin
            q <= d;
        end
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : dff_gen
            // Upper byte (bits 15:8) use byteena[1]
            // Lower byte (bits 7:0) use byteena[0]
            wire bit_enable = (i >= 8) ? byteena[1] : byteena[0];
            
            DFF dff_inst (
                .clk(clk),
                .resetn(resetn),
                .enable(bit_enable),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule