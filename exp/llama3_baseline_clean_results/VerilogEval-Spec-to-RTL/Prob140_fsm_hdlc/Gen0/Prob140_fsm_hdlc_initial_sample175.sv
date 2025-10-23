module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // State register
reg [2:0] nextState; // Next state register
reg discReg, flagReg, errReg; // Output registers

always @(*) begin
    // Default values
    discReg = 1'b0;
    flagReg = 1'b0;
    errReg = 1'b0;

    case(state)
        3'b000: // State 0
            if(in) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b000;
            end
        3'b001: // State 1
            if(in) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b000;
            end
        3'b010: // State 2
            if(in) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b000;
            end
        3'b011: // State 3
            if(in) begin
                nextState = 3'b100;
            end else begin
                nextState = 3'b000;
            end
        3'b100: // State 4
            if(in) begin
                nextState = 3'b101;
            end else begin
                nextState = 3'b000;
            end
        3'b101: // State 5
            if(in) begin
                nextState = 3'b110;
                discReg = 1'b1;
            end else begin
                nextState = 3'b000;
            end
        3'b110: // State 6
            if(in) begin
                nextState = 3'b111;
                errReg = 1'b1;
            end else begin
                nextState = 3'b000;
                flagReg = 1'b1;
            end
        3'b111: // State 7
            if(in) begin
                nextState = 3'b111;
                errReg = 1'b1;
            end else begin
                nextState = 3'b000;
            end
        default:
            nextState = 3'b000;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= discReg;
        flag <= flagReg;
        err <= errReg;
    end
end

endmodule