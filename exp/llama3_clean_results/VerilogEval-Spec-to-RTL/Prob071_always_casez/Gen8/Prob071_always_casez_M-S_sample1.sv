module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    integer i;
    assign pos = (in == 8'b0) ? 3'd0 :
                 (in[0]) ? 3'd0 :
                 (in[1]) ? 3'd1 :
                 (in[2]) ? 3'd2 :
                 (in[3]) ? 3'd3 :
                 (in[4]) ? 3'd4 :
                 (in[5]) ? 3'd5 :
                 (in[6]) ? 3'd6 :
                 (in[7]) ? 3'd7 : 3'd0;

    // Alternative simplified implementation
    // assign pos = (in == 8'b0) ? 3'd0 :
    //             (in[0]) ? 3'd0 :
    //             (in[1]) ? 3'd1 :
    //             (in[2]) ? 3'd2 :
    //             (in[3]) ? 3'd3 :
    //             (in[4]) ? 3'd4 :
    //             (in[5]) ? 3'd5 :
    //             (in[6]) ? 3'd6 :
    //             (in[7]) ? 3'd7 : 3'd0;

    // Another alternative implementation using for loop
    // assign pos = (in == 8'b0) ? 3'd0 : 
    //             (in[0]) ? 3'd0 : 
    //             (in[1] && !in[0]) ? 3'd1 : 
    //             (in[2] && !in[1] && !in[0]) ? 3'd2 : 
    //             (in[3] && !in[2] && !in[1] && !in[0]) ? 3'd3 : 
    //             (in[4] && !in[3] && !in[2] && !in[1] && !in[0]) ? 3'd4 : 
    //             (in[5] && !in[4] && !in[3] && !in[2] && !in[1] && !in[0]) ? 3'd5 : 
    //             (in[6] && !in[5] && !in[4] && !in[3] && !in[2] && !in[1] && !in[0]) ? 3'd6 : 
    //             (in[7] && !in[6] && !in[5] && !in[4] && !in[3] && !in[2] && !in[1] && !in[0]) ? 3'd7 : 3'd0;

    // Using for loop
    // reg [2:0] pos_reg;
    // integer i;
    // always @(*) begin
    //     pos_reg = 3'd0;
    //     for (i = 0; i < 8; i++) begin
    //         if (in[i]) begin
    //             pos_reg = i;
    //             break;
    //         end
    //     end
    // end
    // assign pos = pos_reg;

    // However, for simplicity and performance reasons, let's try to use case statement
    reg [2:0] pos_reg;
    always @(*) begin
        casez (in)
            8'b1??????? : pos_reg = 3'd0;
            8'b01?????? : pos_reg = 3'd1;
            8'b001????? : pos_reg = 3'd2;
            8'b0001???? : pos_reg = 3'd3;
            8'b00001??? : pos_reg = 3'd4;
            8'b000001?? : pos_reg = 3'd5;
            8'b0000001? : pos_reg = 3'd6;
            8'b00000001 : pos_reg = 3'd7;
            default: pos_reg = 3'd0;
        endcase
    end
    assign pos = pos_reg;

endmodule