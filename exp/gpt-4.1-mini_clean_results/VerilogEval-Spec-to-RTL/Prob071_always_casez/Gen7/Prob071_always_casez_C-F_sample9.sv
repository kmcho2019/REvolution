module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    integer i;
    reg found;

    always @* begin
        pos = 3'd0;  // default output for no bits set
        found = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (~found && in[i]) begin
                pos = i[2:0];
                found = 1'b1;
            end
        end
    end

endmodule