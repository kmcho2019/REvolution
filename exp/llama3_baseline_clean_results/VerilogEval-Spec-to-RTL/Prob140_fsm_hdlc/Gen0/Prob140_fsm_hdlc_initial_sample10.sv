module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // S0 to S7
reg [2:0] nextState;

// Next state logic
always @(state or in) begin
    case(state)
        3'b000: nextState = (in == 1'b1) ? 3'b001 : 3'b000; // S0
        3'b001: nextState = (in == 1'b1) ? 3'b010 : 3'b000; // S1
        3'b010: nextState = (in == 1'b1) ? 3'b011 : 3'b000; // S2
        3'b011: nextState = (in == 1'b1) ? 3'b100 : 3'b000; // S3
        3'b100: nextState = (in == 1'b1) ? 3'b101 : 3'b000; // S4
        3'b101: nextState = (in == 1'b1) ? 3'b110 : 3'b000; // S5
        3'b110: nextState = (in == 1'b1) ? 3'b111 : 3'b001; // S6, discard bit
        3'b111: nextState = (in == 1'b1) ? 3'b111 : 3'b000; // S7
        default: nextState = 3'b000;
    endcase
end

// Output logic
always @(state or in) begin
    case(state)
        3'b110: begin disc = (in == 1'b0) ? 1'b1 : 1'b0; flag = 1'b0; err = 1'b0; end // S6
        3'b111: begin disc = 1'b0; flag = (in == 1'b0) ? 1'b1 : 1'b0; err = (in == 1'b1) ? 1'b1 : 1'b0; end // S7
        default: begin disc = 1'b0; flag = 1'b0; err = 1'b0; end
    endcase
end

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
    end
end

endmodule