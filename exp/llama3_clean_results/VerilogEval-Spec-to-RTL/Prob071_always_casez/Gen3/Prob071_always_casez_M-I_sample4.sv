module TopModule(
    input  [7:0] in,
    output logic [2:0] pos
);

    always @(*) begin
        pos = 3'd0;
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i;
                // No break statement; instead, we use the found flag to control the loop
                // But Verilog doesn't allow direct control, we simply let it finish as pos is already set.
            end
        end
    end

endmodule