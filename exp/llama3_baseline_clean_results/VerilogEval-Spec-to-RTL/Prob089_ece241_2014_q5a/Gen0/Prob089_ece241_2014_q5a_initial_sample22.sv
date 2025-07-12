module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: Idle, 1: Running, 2: Sign Bit
reg [31:0] input_num; // register to store the input number
reg [31:0] output_num; // register to store the output number
reg sign_bit; // flag to track the sign bit

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Idle state
        input_num <= 0;
        output_num <= 0;
        sign_bit <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (~areset) begin
                    state <= 1; // transition to Running state
                end
            end
            1: begin // Running state
                input_num <= {input_num[30:0], x}; // shift in the new input bit
                if (x == 1'b1) begin // if we encounter the first 1, it's the sign bit
                    sign_bit <= 1;
                    state <= 2; // transition to Sign Bit state
                end
            end
            2: begin // Sign Bit state
                input_num <= {input_num[30:0], x}; // shift in the new input bit
                if (~areset) begin // if reset is asserted, stop the conversion
                    state <= 0; // transition back to Idle state
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: z <= 0; // Idle state, output 0
        1: z <= 0; // Running state, output 0 until sign bit is encountered
        2: begin // Sign Bit state, output the 2's complement
            output_num = ~input_num + 1;
            z <= output_num[0]; // output the least significant bit of the 2's complement
        end
    endcase
end

endmodule