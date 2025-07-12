module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    integer i;
    reg [2:0] pos_int;

    always @(in) begin
        pos_int = 3'd0;  // Initialize pos_int to 0
        for (i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos_int = i;  // Set pos_int to the position of the first '1'
                break;
            end
        end
        pos = pos_int;  // Assign pos_int to the output pos
    end

endmodule