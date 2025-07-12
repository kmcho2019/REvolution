module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        case (in)
            1'b0: out = 1'b0;
            1'b1: out = 1'b1;
            default: out = 1'b0; // Handle unknown states
        endcase
    end
endmodule