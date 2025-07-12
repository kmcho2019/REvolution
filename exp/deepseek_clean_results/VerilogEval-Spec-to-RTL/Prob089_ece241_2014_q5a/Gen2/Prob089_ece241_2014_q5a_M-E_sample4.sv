module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg complement_flag;
    reg [1:0] shift_reg;  // Small shift register to detect first '1'
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            complement_flag <= 1'b0;
            shift_reg <= 2'b00;
        end else begin
            shift_reg <= {shift_reg[0], x};
            if (!complement_flag && shift_reg[0]) begin
                complement_flag <= 1'b1;
            end
        end
    end

    assign z = complement_flag ? ~x : x;

endmodule