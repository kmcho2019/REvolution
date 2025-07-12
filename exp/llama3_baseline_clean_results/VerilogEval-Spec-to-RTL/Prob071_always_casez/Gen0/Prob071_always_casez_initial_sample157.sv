module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 0;
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = i + 1; // Add 1 because we're using 1-based indexing
                break;
            end
        end
    end

endmodule