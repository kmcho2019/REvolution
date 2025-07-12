module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11; // output 3 if MSB is 1
        end else if (in[2]) begin
            pos = 2'b10; // output 2 if second bit is 1
        end else if (in[1]) begin
            pos = 2'b01; // output 1 if third bit is 1
        end else if (in[0]) begin
            pos = 2'b00; // output 0 if LSB is 1
        end else begin
            pos = 2'b00; // output 0 if no bits are 1
        end
    end

endmodule