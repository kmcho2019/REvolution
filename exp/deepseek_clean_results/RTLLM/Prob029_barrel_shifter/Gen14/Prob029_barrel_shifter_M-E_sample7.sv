module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Decoder to create shift amount
    wire [7:0] shift_amount;
    assign shift_amount = (ctrl == 3'b000) ? 8'd0 :
                         (ctrl == 3'b001) ? 8'd1 :
                         (ctrl == 3'b010) ? 8'd2 :
                         (ctrl == 3'b011) ? 8'd3 :
                         (ctrl == 3'b100) ? 8'd4 :
                         (ctrl == 3'b101) ? 8'd5 :
                         (ctrl == 3'b110) ? 8'd6 :
                                          8'd7;

    // Crossbar implementation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: crossbar
            // Calculate rotated index with wrap-around
            wire [2:0] sel = (i >= shift_amount) ? 
                            (i - shift_amount[2:0]) : 
                            (8 - shift_amount[2:0] + i);
            
            // 8:1 mux for each output bit
            assign out[i] = (sel == 3'd0) ? in[0] :
                           (sel == 3'd1) ? in[1] :
                           (sel == 3'd2) ? in[2] :
                           (sel == 3'd3) ? in[3] :
                           (sel == 3'd4) ? in[4] :
                           (sel == 3'd5) ? in[5] :
                           (sel == 3'd6) ? in[6] :
                                           in[7];
        end
    endgenerate

endmodule