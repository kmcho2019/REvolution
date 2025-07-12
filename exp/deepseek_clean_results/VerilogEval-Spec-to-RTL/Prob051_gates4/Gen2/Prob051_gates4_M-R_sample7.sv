module TopModule (
    input [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(*) begin
        case (in)
            4'b0000: begin
                out_and = 1'b0;
                out_or  = 1'b0;
                out_xor = 1'b0;
            end
            4'b0001: begin
                out_and = 1'b0;
                out_or  = 1'b1;
                out_xor = 1'b1;
            end
            4'b0010: begin
                out_and = 1'b0;
                out_or  = 1'b1;
                out_xor = 1'b1;
            end
            // ... (all other 14 cases would be listed here)
            default: begin
                out_and = &in;
                out_or  = |in;
                out_xor = ^in;
            end
        endcase
    end

endmodule