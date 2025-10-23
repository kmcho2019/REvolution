module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: IDLE, 1: SIGN, 2: COUNT, 3: OUTPUT
reg [1:0] nextState;
reg [31:0] count; // to count the number of bits
reg [31:0] outputReg; // to store the output
reg [31:0] tempReg; // temporary register to store the input bits
reg [31:0] bitCount; // to count the total number of bits
reg sign; // to store the sign bit

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // IDLE state
        count <= 0;
        outputReg <= 0;
        tempReg <= 0;
        bitCount <= 0;
        sign <= 0;
    end else begin
        case(state)
            0: begin // IDLE state
                nextState <= 1; // move to SIGN state
            end
            1: begin // SIGN state
                if (x) begin // if the bit is 1, it's a negative number
                    sign <= 1;
                end
                nextState <= 2; // move to COUNT state
                bitCount <= bitCount + 1;
                tempReg[bitCount - 1] <= x;
            end
            2: begin // COUNT state
                nextState <= 2; // stay in COUNT state
                bitCount <= bitCount + 1;
                tempReg[bitCount - 1] <= x;
                if (bitCount == 32) begin // if all 32 bits are received
                    if (sign) begin // if it's a negative number
                        for (int i = 0; i < 32; i++) begin
                            outputReg[i] <= ~tempReg[i]; // invert the bits
                        end
                        outputReg[31] <= 1; // set the MSB to 1
                    end else begin // if it's a positive number
                        outputReg <= tempReg;
                    end
                    nextState <= 3; // move to OUTPUT state
                end
            end
            3: begin // OUTPUT state
                nextState <= 3; // stay in OUTPUT state
                if (count == 0) begin
                    z <= outputReg[0];
                    count <= 31;
                    outputReg <= outputReg >> 1;
                end else begin
                    count <= count - 1;
                    z <= outputReg[count];
                    outputReg <= outputReg >> 1;
                end
                if (count == 1) begin
                    nextState <= 0; // move back to IDLE state
                end
            end
        endcase
        state <= nextState;
    end
end

endmodule