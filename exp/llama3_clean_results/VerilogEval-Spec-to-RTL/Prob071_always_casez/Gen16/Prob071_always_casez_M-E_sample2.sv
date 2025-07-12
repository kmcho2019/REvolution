module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_int;
    
    always @(in) begin
        pos_int = 3'd0;
        if (in[7:4]!= 8'b0000) begin
            if (in[7:6]!= 2'b00) begin
                if (in[7]) begin
                    pos_int = 3'd7;
                end else begin
                    pos_int = 3'd6;
                end
            end else if (in[5:4]!= 2'b00) begin
                if (in[5]) begin
                    pos_int = 3'd5;
                end else begin
                    pos_int = 3'd4;
                end
            end
        end else if (in[3:0]!= 4'b0000) begin
            if (in[3:2]!= 2'b00) begin
                if (in[3]) begin
                    pos_int = 3'd3;
                end else begin
                    pos_int = 3'd2;
                end
            end else if (in[1:0]!= 2'b00) begin
                if (in[1]) begin
                    pos_int = 3'd1;
                end else begin
                    pos_int = 3'd0;
                end
            end
        end
        pos = pos_int;
    end

endmodule