module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [2:0] shift_reg;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], x};
        end
    end

    // Mealy output: detect "101" in the shift register when new x is 1
    assign z = (shift_reg[2:1] == 2'b10) & x;

endmodule