module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: IDLE, 1: COMPLEMENT
reg carry; // carry flag
reg [1:0] output_temp; // temporary output

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // reset to IDLE state
        carry <= 1'b0; // reset carry flag
        output_temp <= 1'b0; // reset output
    end else begin
        case(state)
            0: begin // IDLE state
                state <= 1; // move to COMPLEMENT state when reset is released
                carry <= 1'b1; // set carry flag to 1 for 2's complement
                output_temp <= 1'b0; // reset output
            end
            1: begin // COMPLEMENT state
                // invert input bit and add to running sum
                output_temp <= ~(x ^ carry); // XOR with carry to add 1
                carry <= x & carry; // update carry flag
            end
        endcase
    end
end

always @(*) begin
    case(state)
        0: z <= 1'b0; // output 0 in IDLE state
        1: z <= output_temp; // output complement in COMPLEMENT state
    endcase
end

endmodule