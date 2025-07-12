module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Parallel computation paths
    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    wire sum_zero = (sum == 8'b0);
    wire diff_zero = (diff == 8'b0);

    // Single mux stage for both outputs
    always @(*) begin
        case (do_sub)
            0: begin
                out = sum;
                result_is_zero = sum_zero;
            end
            1: begin
                out = diff;
                result_is_zero = diff_zero;
            end
        endcase
    end

endmodule