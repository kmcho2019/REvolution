module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // default output value
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i; // report the first '1' bit position
                break;
            end
        end
    end

endmodule