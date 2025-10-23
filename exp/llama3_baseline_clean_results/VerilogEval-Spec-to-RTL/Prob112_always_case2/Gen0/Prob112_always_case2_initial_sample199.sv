module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        if (in[3] == 1'b1) begin
            pos = 2'd3;  // Most significant bit is '1'
        end else if (in[2] == 1'b1) begin
            pos = 2'd2;
        end else if (in[1] == 1'b1) begin
            pos = 2'd1;
        end else if (in[0] == 1'b1) begin
            pos = 2'd0;
        end else begin
            pos = 2'd0;  // All bits are '0', output '0'
        end
    end

endmodule