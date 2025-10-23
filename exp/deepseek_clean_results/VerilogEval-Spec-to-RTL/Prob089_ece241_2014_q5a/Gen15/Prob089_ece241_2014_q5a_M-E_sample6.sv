module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [63:0] shift_reg;  // Large enough for practical input sizes
    wire first_one_found = |shift_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 64'b0;
        end else begin
            if (!first_one_found) begin
                shift_reg <= {shift_reg[62:0], x};
            end
        end
    end

    assign z = first_one_found ? ~x : x;

endmodule