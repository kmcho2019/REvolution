module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    wire [3:0] in_vec = {a,b,c,d};

    always @(*) begin
        case (in_vec)
            4'd2, 4'd7, 4'd15: begin
                out_sop = 1'b1;
                out_pos = 1'b0;
            end
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6, 4'd9, 4'd10, 4'd13, 4'd14: begin
                out_sop = 1'b0;
                out_pos = 1'b1;
            end
            default: begin
                // Inputs 3,8,11,12 do not occur
                out_sop = 1'b0; 
                out_pos = 1'b0;
            end
        endcase
    end

endmodule