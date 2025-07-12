module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Shift register to track first '1' position
    reg [1:0] shift_reg;
    wire first_one_detected = shift_reg[0] | shift_reg[1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 2'b00;
        end else begin
            // Shift in new bits only if not already detected first '1'
            if (!first_one_detected) begin
                shift_reg <= {shift_reg[0], x};
            end
        end
    end

    // Output is x when no '1' detected yet, ~x after first '1'
    assign z = first_one_detected ? ~x : x;

endmodule