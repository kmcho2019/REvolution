module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    wire [7:0] in_reversed;
    assign in_reversed = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
    
    reg [2:0] pos_reg;
    integer i;
    always @(*) begin
        pos_reg = 3'd0;
        for (i = 0; i < 8; i++) begin
            if (in_reversed[i]) begin
                pos_reg = 3'd7 - i;
                break;
            end
        end
    end
    assign pos = pos_reg;

    // Alternative implementation using a binary search approach
    // reg [2:0] pos_reg;
    // always @(*) begin
    //     if (in[4] || in[5] || in[6] || in[7]) begin
    //         if (in[6] || in[7]) begin
    //             if (in[7]) begin
    //                 pos_reg = 3'd7;
    //             end else begin
    //                 pos_reg = 3'd6;
    //             end
    //         end else if (in[5]) begin
    //             pos_reg = 3'd5;
    //         end else begin
    //             pos_reg = 3'd4;
    //         end
    //     end else begin
    //         if (in[2] || in[3]) begin
    //             if (in[3]) begin
    //                 pos_reg = 3'd3;
    //             end else begin
    //                 pos_reg = 3'd2;
    //             end
    //         end else if (in[1]) begin
    //             pos_reg = 3'd1;
    //         end else if (in[0]) begin
    //             pos_reg = 3'd0;
    //         end else begin
    //             pos_reg = 3'd0;
    //         end
    //     end
    // end
    // assign pos = pos_reg;

endmodule