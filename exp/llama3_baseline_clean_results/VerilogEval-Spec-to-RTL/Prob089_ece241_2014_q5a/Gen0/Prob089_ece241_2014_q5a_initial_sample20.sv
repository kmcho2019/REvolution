module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // idle (2'b00) and running (2'b01)
reg [31:0] num; // to accumulate input number
reg [31:0] ones; // to store 1's for flipping bits of input number
reg [31:0] result; // 2's complement of input number
reg carry; // to store carry from addition

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset state to idle
        num <= 32'b0; // reset accumulated number
        ones <= 32'b0; // reset ones for flipping bits
        carry <= 1'b0; // reset carry
    end else if (state == 2'b00) begin
        if (!areset) begin // check if reset is released
            state <= 2'b01; // transition to running state
        end
    end else if (state == 2'b01) begin
        num <= {num[30:0], x}; // accumulate input number
        ones <= {ones[30:0], ~x}; // accumulate 1's for flipping bits
        if (areset) begin
            state <= 2'b00; // transition back to idle state on reset
            num <= 32'b0; // reset accumulated number
            ones <= 32'b0; // reset ones for flipping bits
            carry <= 1'b0; // reset carry
        end
    end
end

always @ (posedge clk) begin
    if (state == 2'b01) begin
        result <= ones + 1'b1 + carry; // calculate 2's complement
        carry <= result[31]; // update carry for next bit
        z <= result[0]; // output least significant bit of result
    end else begin
        z <= 1'b0; // output 0 when not in running state
    end
end

endmodule