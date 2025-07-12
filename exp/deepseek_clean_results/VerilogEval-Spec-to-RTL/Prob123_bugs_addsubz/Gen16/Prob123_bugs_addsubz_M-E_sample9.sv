module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    
    // Early zero detection
    wire zero_add = (a == ~b + 1);  // a + b == 0
    wire zero_sub = (a == b);       // a - b == 0
    
    always @(*) begin
        case (do_sub)
            1'b0: begin
                out = sum;
                result_is_zero = zero_add;
            end
            1'b1: begin
                out = diff;
                result_is_zero = zero_sub;
            end
        endcase
    end

    // Power gating for unused path (synthesis pragma)
    // synopsys translate_off
    wire unused = do_sub ? sum : diff;
    // synopsys translate_on

endmodule