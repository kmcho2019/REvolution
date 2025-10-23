module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

reg A_greater_reg;
reg A_equal_reg;
reg A_less_reg;

always @(*) begin
    casez ({A[2], B[2]})
        2'b00: begin
            casez ({A[1], B[1]})
                2'b00: begin
                    if (A[0] > B[0]) begin
                        A_greater_reg = 1'b1;
                        A_equal_reg = 1'b0;
                        A_less_reg = 1'b0;
                    end else if (A[0] < B[0]) begin
                        A_greater_reg = 1'b0;
                        A_equal_reg = 1'b0;
                        A_less_reg = 1'b1;
                    end else begin
                        A_greater_reg = 1'b0;
                        A_equal_reg = 1'b1;
                        A_less_reg = 1'b0;
                    end
                end
                2'b01: begin
                    A_greater_reg = 1'b0;
                    A_equal_reg = 1'b0;
                    A_less_reg = 1'b1;
                end
                2'b10: begin
                    A_greater_reg = 1'b1;
                    A_equal_reg = 1'b0;
                    A_less_reg = 1'b0;
                end
                default: begin
                    // Don't care condition
                end
            endcase
        end
        2'b01: begin
            A_greater_reg = 1'b0;
            A_equal_reg = 1'b0;
            A_less_reg = 1'b1;
        end
        2'b10: begin
            A_greater_reg = 1'b1;
            A_equal_reg = 1'b0;
            A_less_reg = 1'b0;
        end
        default: begin
            // Don't care condition
        end
    endcase
end

assign A_greater = A_greater_reg;
assign A_equal = A_equal_reg;
assign A_less = A_less_reg;

endmodule