module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 0; // default to 0 if no '1' is found
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i; // report the position of the first '1'
                break; // no need to check further bits
            end
        end
    end

endmodule