module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (|in[3:0]) begin // Lower half has a set bit
        if (in[0])       pos = 3'd0;
        else if (in[1])  pos = 3'd1;
        else if (in[2])  pos = 3'd2;
        else             pos = 3'd3;
    end
    else if (|in[7:4]) begin // Upper half has a set bit
        if (in[4])      pos = 3'd4;
        else if (in[5]) pos = 3'd5;
        else if (in[6]) pos = 3'd6;
        else            pos = 3'd7;
    end
    else begin // No bits set
        pos = 3'd0;
    end
end

endmodule