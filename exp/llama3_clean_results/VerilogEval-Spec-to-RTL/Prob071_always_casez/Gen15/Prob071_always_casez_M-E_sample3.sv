module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

reg [2:0] pos_reg;

always @(in) begin
    reg [7:0] temp;
    temp = in;
    pos_reg = 3'd0;
    
    // Check the first 4 bits
    if (temp[7] || temp[6] || temp[5] || temp[4]) begin
        // Check the first 2 bits
        if (temp[7] || temp[6]) begin
            // Check the MSB
            if (temp[7]) begin
                pos_reg = 3'd7;
            end else begin
                pos_reg = 3'd6;
            end
        end else begin
            // Check the next 2 bits
            if (temp[5]) begin
                pos_reg = 3'd5;
            end else begin
                pos_reg = 3'd4;
            end
        end
    end else begin
        // Check the last 4 bits
        if (temp[3] || temp[2] || temp[1] || temp[0]) begin
            // Check the first 2 bits
            if (temp[3] || temp[2]) begin
                // Check the MSB
                if (temp[3]) begin
                    pos_reg = 3'd3;
                end else begin
                    pos_reg = 3'd2;
                end
            end else begin
                // Check the next 2 bits
                if (temp[1]) begin
                    pos_reg = 3'd1;
                end else begin
                    pos_reg = 3'd0;
                end
            end
        end
    end
end

assign pos = pos_reg;

endmodule