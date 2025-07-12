module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    reg [7:0] inverted;
    reg [7:0] and_result;
    reg [2:0] decoder_output;

    always @(*) begin
        inverted = ~in;
        and_result = in & ({8{1'b0}} >> 1) | (in & inverted);
        decoder_output = 3'd0;
        if (and_result[0]) decoder_output = 3'd0;
        else if (and_result[1]) decoder_output = 3'd1;
        else if (and_result[2]) decoder_output = 3'd2;
        else if (and_result[3]) decoder_output = 3'd3;
        else if (and_result[4]) decoder_output = 3'd4;
        else if (and_result[5]) decoder_output = 3'd5;
        else if (and_result[6]) decoder_output = 3'd6;
        else if (and_result[7]) decoder_output = 3'd7;
        pos = decoder_output;
    end

endmodule