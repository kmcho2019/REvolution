module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    integer i;

    always @(*) begin
        pos = 3'd0; // initialize pos to 0
        for (i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin // check each bit from LSB to MSB
                pos = i; // store the position of the first '1'
                break; // exit the loop as soon as a '1' is found
            end
        end
    end

endmodule