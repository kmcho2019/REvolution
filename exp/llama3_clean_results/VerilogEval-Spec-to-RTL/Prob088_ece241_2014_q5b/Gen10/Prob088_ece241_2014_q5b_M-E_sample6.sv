module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [0:0] counter; // 1-bit counter to track the state

always @(posedge clk or posedge areset) begin
    if(areset) begin
        counter <= 1'b0; // Reset to state A
    end else begin
        case(counter)
            1'b0: counter <= x; // Increment counter when x is 1 in state A
            1'b1: counter <= 1'b1; // Remain in state B
        endcase
    end
end

always @(*) begin
    z = (counter == 1'b0 && x == 1'b0) || (counter == 1'b1 && x == 1'b1); // Generate output z based on state and input x
end

endmodule