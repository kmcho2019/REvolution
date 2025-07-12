module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    wire [3:0] priority;

    // Generate one-hot priority signals with minimal inversions
    assign priority[0] = in[0];
    assign priority[1] = in[1] & ~priority[0];
    assign priority[2] = in[2] & ~priority[1] & ~priority[0];
    assign priority[3] = in[3] & ~priority[2] & ~priority[1] & ~priority[0];

    always @(*) begin
        casez (priority)
            4'b0001: pos = 2'd0;
            4'b0010: pos = 2'd1;
            4'b0100: pos = 2'd2;
            4'b1000: pos = 2'd3;
            default: pos = 2'd0; // no bits set
        endcase
    end

endmodule