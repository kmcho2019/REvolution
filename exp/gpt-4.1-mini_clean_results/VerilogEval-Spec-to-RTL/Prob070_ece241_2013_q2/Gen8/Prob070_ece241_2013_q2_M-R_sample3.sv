module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    wire [3:0] num = {a,b,c,d};

    always @(*) begin
        case (num)
            4'd2, 4'd7, 4'd15: begin
                // Inputs for decimal 2,7,15 produce logic 1
                out_sop = 1'b1;
                out_pos = 1'b1;
            end
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6,
            4'd9, 4'd10, 4'd13, 4'd14: begin
                // Inputs listed produce logic 0
                out_sop = 1'b0;
                out_pos = 1'b0;
            end
            // 3,8,11,12 never occur, assign output 0 to be safe
            default: begin
                out_sop = 1'b0;
                out_pos = 1'b0;
            end
        endcase
    end

endmodule