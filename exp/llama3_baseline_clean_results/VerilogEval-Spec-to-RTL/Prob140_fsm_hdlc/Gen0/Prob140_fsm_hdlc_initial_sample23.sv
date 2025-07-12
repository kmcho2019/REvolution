module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // Current state
reg [1:0] nextState; // Next state
reg [2:0] countOnes; // Counter for consecutive ones
reg discReg, flagReg, errReg; // Registers for output signals

// Assign initial values
initial begin
    state = 2'b00; // Initial state S0
    countOnes = 3'b000; // Reset counter
    discReg = 1'b0;
    flagReg = 1'b0;
    errReg = 1'b0;
end

// Sequential logic
always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state
        countOnes <= 3'b000; // Reset counter
        discReg <= 1'b0;
        flagReg <= 1'b0;
        errReg <= 1'b0;
    end else begin
        state <= nextState;
        if (in) begin
            countOnes <= countOnes + 1;
        end else begin
            countOnes <= 3'b000; // Reset counter
        end
        discReg <= (state == 2'b11 && !in);
        flagReg <= (state == 2'b11 && in);
        errReg <= (countOnes >= 3'b111);
    end
end

// Combinational logic
always @ (*) begin
    case (state)
        2'b00: begin // S0
            if (in) begin
                nextState = 2'b01; // Move to S1
            end else begin
                nextState = 2'b00; // Stay in S0
            end
        end
        2'b01: begin // S1
            if (in) begin
                nextState = 2'b10; // Move to S2
            end else begin
                nextState = 2'b00; // Move to S0
            end
        end
        2'b10: begin // S2
            if (in) begin
                nextState = 2'b10; // Stay in S2
            end else begin
                nextState = 2'b00; // Move to S0
            end
        end
        2'b11: begin // S3
            if (in) begin
                nextState = 2'b11; // Stay in S3
            end else begin
                nextState = 2'b00; // Move to S0
            end
        end
        default: begin
            nextState = 2'b00; // Default state S0
        end
    endcase
    
    if (countOnes >= 3'b101) begin
        nextState = 2'b11; // Move to S3
    end
end

assign disc = discReg;
assign flag = flagReg;
assign err = errReg;

endmodule