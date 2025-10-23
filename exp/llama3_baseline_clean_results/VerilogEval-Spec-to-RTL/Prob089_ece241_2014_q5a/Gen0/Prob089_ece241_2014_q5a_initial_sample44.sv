module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state = 2'b00;  // 'start' = 2'b00, 'complement' = 2'b01
reg [31:0] count = 32'd0;  // Accumulated value
reg [31:0] result = 32'd0;  // 2's complement of input

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;  // Reset state to 'start'
        count <= 32'd0;  // Reset accumulated value
        result <= 32'd0;  // Reset 2's complement result
    end else begin
        case (state)
            2'b00: begin  // 'start' state
                if (x == 1'b1) begin
                    state <= 2'b01;  // Move to 'complement' state
                    count <= 32'd1;  // Set accumulated value to 1
                end else begin
                    state <= 2'b01;  // Move to 'complement' state
                    count <= 32'd0;  // Set accumulated value to 0
                end
            end
            2'b01: begin  // 'complement' state
                if (x == 1'b1) begin
                    count <= count + 1;  // Increment accumulated value
                end
                result <= ~(count) + 1;  // Calculate 2's complement
                z <= result[0];  // Output least significant bit
                result <= result >> 1;  // Right shift result
            end
        endcase
    end
end

endmodule