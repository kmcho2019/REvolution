module TopModule(
    input  [3:0] in,
    output [1:0] pos
    );

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11; // bit 3 is high
        end else if (in[2]) begin
            pos = 2'b10; // bit 2 is high
        end else if (in[1]) begin
            pos = 2'b01; // bit 1 is high
        end else if (in[0]) begin
            pos = 2'b00; // bit 0 is high
        end else begin
            pos = 2'b00; // no bit is high
        end
    end

endmodule