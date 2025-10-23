module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Parallel computation of both operations
    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    
    // Early zero detection
    wire sum_zero = (sum == 8'b0);
    wire diff_zero = (diff == 8'b0);
    
    always @(*) begin
        // Select appropriate result
        case (do_sub)
            1'b0: begin
                out = sum;
                result_is_zero = sum_zero;
            end
            1'b1: begin
                out = diff;
                result_is_zero = diff_zero;
            end
        endcase
    end

endmodule