module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] temp_pos;

    always @(in) begin
        temp_pos = 3'b000;  // Initialize temp_pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                temp_pos = i;  // Assign the position of the first '1'
                break;
            end
        end
    end

    assign pos = temp_pos;

endmodule