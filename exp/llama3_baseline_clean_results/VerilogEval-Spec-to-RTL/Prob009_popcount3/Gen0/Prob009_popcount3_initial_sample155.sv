module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    always @(*) begin
        if (in[0] == 1'b1) begin
            if (in[1] == 1'b1) begin
                if (in[2] == 1'b1) begin
                    out = 2'b11;  // 3 '1's
                end else begin
                    out = 2'b10;  // 2 '1's
                end
            end else begin
                if (in[2] == 1'b1) begin
                    out = 2'b10;  // 2 '1's
                end else begin
                    out = 2'b01;  // 1 '1'
                end
            end
        end else begin
            if (in[1] == 1'b1) begin
                if (in[2] == 1'b1) begin
                    out = 2'b10;  // 2 '1's
                end else begin
                    out = 2'b01;  // 1 '1'
                end
            end else begin
                if (in[2] == 1'b1) begin
                    out = 2'b01;  // 1 '1'
                end else begin
                    out = 2'b00;  // 0 '1's
                end
            end
        end
    end

endmodule