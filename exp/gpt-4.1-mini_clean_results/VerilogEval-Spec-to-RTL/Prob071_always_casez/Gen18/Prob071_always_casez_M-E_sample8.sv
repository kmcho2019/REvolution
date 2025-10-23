module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    wire [7:0] one_hot;

    // Generate one-hot encoding for the first set bit using casez and wildcards
    assign one_hot = (in == 8'b0) ? 8'b0 : 
                     (in[0] ? 8'b00000001 :
                      in[1] ? 8'b00000010 :
                      in[2] ? 8'b00000100 :
                      in[3] ? 8'b00001000 :
                      in[4] ? 8'b00010000 :
                      in[5] ? 8'b00100000 :
                      in[6] ? 8'b01000000 :
                              8'b10000000);

    // Decode one-hot vector to position using a simple combinational case
    always @(*) begin
        case (one_hot)
            8'b00000001: pos = 3'd0;
            8'b00000010: pos = 3'd1;
            8'b00000100: pos = 3'd2;
            8'b00001000: pos = 3'd3;
            8'b00010000: pos = 3'd4;
            8'b00100000: pos = 3'd5;
            8'b01000000: pos = 3'd6;
            8'b10000000: pos = 3'd7;
            default:     pos = 3'd0; // no bits set
        endcase
    end

endmodule