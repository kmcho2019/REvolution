module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        if (in[7]) begin
            pos_reg = 3'd7;
        end else if (in[6]) begin
            pos_reg = 3'd6;
        end else if (in[5]) begin
            pos_reg = 3'd5;
        end else if (in[4]) begin
            // Check the lower 4 bits
            if (in[3]) begin
                pos_reg = 3'd3;
            end else if (in[2]) begin
                pos_reg = 3'd2;
            end else if (in[1]) begin
                pos_reg = 3'd1;
            end else if (in[0]) begin
                pos_reg = 3'd0;
            end else begin
                pos_reg = 3'd0; // Default if no '1' is found
            end
        end else begin
            // If the upper 4 bits are all 0, check the lower 4 bits directly
            if (in[3]) begin
                pos_reg = 3'd3;
            end else if (in[2]) begin
                pos_reg = 3'd2;
            end else if (in[1]) begin
                pos_reg = 3'd1;
            end else if (in[0]) begin
                pos_reg = 3'd0;
            end else begin
                pos_reg = 3'd0; // Default if no '1' is found
            end
        end
    end

    assign pos = pos_reg;

endmodule