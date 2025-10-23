module TopModule (
    input [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // Initialize output to 0
        if (in[0] == 1'd1) pos = 3'd0;
        else if (in[1] == 1'd1) pos = 3'd1;
        else if (in[2] == 1'd1) pos = 3'd2;
        else if (in[3] == 1'd1) pos = 3'd3;
        else if (in[4] == 1'd1) pos = 3'd4;
        else if (in[5] == 1'd1) pos = 3'd5;
        else if (in[6] == 1'd1) pos = 3'd6;
        else if (in[7] == 1'd1) pos = 3'd7;
    end

endmodule