module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0=A, 1=B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: state <= x ? 1'b1 : 1'b0;  // A -> B if x=1, else stay A
                1'b1: state <= 1'b1;              // Always stay in B
            endcase
        end
    end

    assign z = x ^ state;  // Equivalent to (state==0 && x) || (state==1 && ~x)

endmodule