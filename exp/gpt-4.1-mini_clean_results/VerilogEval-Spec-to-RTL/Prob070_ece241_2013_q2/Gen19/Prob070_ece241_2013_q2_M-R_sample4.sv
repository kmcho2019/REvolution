module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a single 4-bit vector for ease of use
    wire [3:0] N = {a,b,c,d};

    always @(*) begin
        case (N)
            4'd2, 4'd7, 4'd15: begin
                out_sop = 1'b1;
                out_pos = 1'b1; // since these are not zeros for out_pos
            end
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6, 4'd9, 4'd10, 4'd13, 4'd14: begin
                out_sop = 1'b0;
                out_pos = 1'b0; // zeros for out_pos
            end
            // inputs 3,8,11,12 never occur - assign safe defaults
            default: begin
                out_sop = 1'b0;
                out_pos = 1'b1;
            end
        endcase
    end

endmodule