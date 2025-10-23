module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset and sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00; // Reset state
    end else begin
        case (state)
            2'b00: state <= x ? 2'b10 : 2'b00; // From idle to '1' detected
            2'b10: state <= x ? 2'b11 : 2'b00; // From '1' to '0' then '1' detected, or back to idle
            2'b11: state <= 2'b00; // Reset state after '101' detected
            default: state <= 2'b00; // Default to idle state
        endcase
    end
end

// Output logic
assign z = (state == 2'b11); // Assert z when '101' sequence detected

endmodule