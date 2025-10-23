module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    reg [2:0] pos_reg;
    assign pos = pos_reg;

    always @(*) begin
        pos_reg = 3'd0; // Default value if no '1' is found
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin // If current bit is '1'
                pos_reg = i; // Set pos_reg to the position of the first '1'
                break; // Exit the loop as we've found the first '1'
            end
        end
    end

endmodule