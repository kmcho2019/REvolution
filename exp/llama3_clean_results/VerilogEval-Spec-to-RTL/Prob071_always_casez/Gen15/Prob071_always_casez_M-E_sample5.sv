module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    always @(*) begin
        if (in[7]) begin
            pos = 3'd7;
        end else if (in[6]) begin
            pos = 3'd6;
        end else if (in[5]) begin
            pos = 3'd5;
        end else if (in[4]) begin
            if (in[4]) begin
                if (in[3]) begin
                    pos = 3'd3;
                end else if (in[2]) begin
                    pos = 3'd2;
                end else if (in[1]) begin
                    pos = 3'd1;
                end else if (in[0]) begin
                    pos = 3'd0;
                end else begin
                    pos = 3'd0;
                end
            end else begin
                pos = 3'd0;
            end
        end else if (in[3]) begin
            pos = 3'd3;
        end else if (in[2]) begin
            pos = 3'd2;
        end else if (in[1]) begin
            pos = 3'd1;
        end else if (in[0]) begin
            pos = 3'd0;
        end else begin
            pos = 3'd0;
        end
    end

endmodule