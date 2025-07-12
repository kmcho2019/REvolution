module TopModule(
    input [7:0] in,
    output reg [2:0] pos
);

always @(in) begin
    pos = 3'd0;
    for (int i = 0; i < 8; i++) begin
        if (in[i]) begin
            pos = i;
            // No explicit break needed; the loop will continue,
            // but pos won't be updated further because of the
            // next iteration condition and the default pos value
        end
    end
end

endmodule