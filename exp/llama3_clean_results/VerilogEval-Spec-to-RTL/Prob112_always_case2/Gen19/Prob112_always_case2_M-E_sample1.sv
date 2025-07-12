module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    reg [1:0] pos_temp;

    always @(*) begin
        pos_temp = 2'b00; // Default to 0
        if (in[3]) begin
            pos_temp = 2'b11; // Most significant bit
        end else if (in[2]) begin
            pos_temp = 2'b10;
        end else if (in[1]) begin
            pos_temp = 2'b01;
        end else if (in[0]) begin
            pos_temp = 2'b00; // Least significant bit
        end
        pos = pos_temp;
    end

endmodule