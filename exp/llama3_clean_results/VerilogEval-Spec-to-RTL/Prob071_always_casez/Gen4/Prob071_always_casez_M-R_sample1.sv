module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

    always @(*) begin
        pos = 3'd0;
        reg [2:0] temp;
        reg found = 1'b0;
        
        for (int i = 0; i < 8; i++) begin
            if (!found && in[i]) begin
                temp = i;
                found = 1'b1;
            end
        end
        
        pos = found ? temp : 3'd0;
    end

endmodule