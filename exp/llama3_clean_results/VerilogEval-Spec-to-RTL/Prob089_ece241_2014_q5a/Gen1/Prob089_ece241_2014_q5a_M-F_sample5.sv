module TopModule(
    input clk,
    input areset,
    input x,
    output reg z // Declare z as a reg for procedural assignment
);

reg seen_one; // State variable to track if the first '1' has been seen
reg carry; // Carry bit to handle addition of 1

always @(posedge clk or posedge areset) begin
    if (areset) begin
        seen_one <= 1'b0; // Reset state
        carry <= 1'b0; // Reset carry
    end else if (~seen_one && x) begin // Transition to "seen first '1'" state
        seen_one <= 1'b1;
        carry <= 1'b1; // Set carry when first '1' is seen
    end else if (seen_one && ~x) begin // If already seen '1' and current bit is '0', reset carry
        carry <= 1'b0;
    end
end

always @(posedge clk) begin
    if (seen_one) begin // If we've seen the first '1'
        if (carry) begin // And there's a carry
            z <= ~(x ^ carry); // Invert input considering carry
        end else begin
            z <= ~x; // Simply invert input if no carry
        end
    end else begin // If we haven't seen the first '1' yet
        z <= ~x; // Simply invert input
    end
end

endmodule