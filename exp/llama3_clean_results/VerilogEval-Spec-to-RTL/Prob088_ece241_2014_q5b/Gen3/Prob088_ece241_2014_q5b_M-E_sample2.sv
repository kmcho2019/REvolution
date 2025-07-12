module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg in_B; // Flag to indicate if we are in state B

always @(posedge clk or posedge areset) begin
    if(areset) begin
        in_B <= 1'b0; // Reset to state A
    end else begin
        if(!in_B && x) begin // Transition from A to B
            in_B <= 1'b1;
        end
    end
end

always @(*) begin
    if(in_B) begin // In state B, z follows x but with an inverted phase
        z = ~x;
    end else begin // In state A, z is directly determined by x
        z = x;
    end
end

endmodule