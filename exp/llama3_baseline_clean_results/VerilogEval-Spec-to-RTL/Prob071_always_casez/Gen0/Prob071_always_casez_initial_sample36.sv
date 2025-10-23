module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

always @(*) begin
    pos = 3'd0; // default to 0 if no '1' bits found
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1'b1) begin
            pos = i; // output position of first '1' bit
            break; // stop searching once first '1' bit is found
        end
    end
end

endmodule