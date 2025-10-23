module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // 0: IDLE, 1: RUNNING
reg [31:0] input_reg; // to store the input bits
reg [31:0] output_reg; // to store the output bits
reg [4:0] bit_count; // to keep track of the number of input bits
reg carry; // carry bit for 2's complement

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to IDLE state
        input_reg <= 0; // reset input register
        output_reg <= 0; // reset output register
        bit_count <= 0; // reset bit count
        carry <= 1; // reset carry bit
    end else if (state == 0) begin
        if (~areset) begin
            state <= 1; // transition to RUNNING state when reset is released
            input_reg <= 0; // reset input register
            output_reg <= 0; // reset output register
            bit_count <= 0; // reset bit count
            carry <= 1; // reset carry bit
        end
    end else if (state == 1) begin
        if (x) begin
            if (carry) begin
                z <= 1; // output is the inverse of the current input bit if carry is 1
            end else begin
                z <= x; // output is the current input bit if carry is 0
            end
            carry <= ~x & carry; // update carry bit
        end else begin
            if (carry) begin
                z <= 0; // output is the inverse of the current input bit if carry is 1
            end else begin
                z <= x; // output is the current input bit if carry is 0
            end
            carry <= carry; // update carry bit
        end
        input_reg <= {input_reg[30:0], x}; // shift input bits to the left
        bit_count <= bit_count + 1; // increment bit count
        if (areset) begin
            state <= 0; // transition to IDLE state when reset is asserted
        end
    end
end

endmodule