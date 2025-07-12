module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // 3-bit state register (8 states)

// State machine logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset state machine
    end else begin
        case(state)
            3'b000: // S0
                if(IN) state <= 3'b001;
                else state <= 3'b000;
            3'b001: // S1
                if(!IN) state <= 3'b010;
                else state <= 3'b000;
            3'b010: // S2
                if(!IN) state <= 3'b011;
                else state <= 3'b000;
            3'b011: // S3
                if(IN) state <= 3'b100;
                else state <= 3'b000;
            3'b100: // S4
                if(IN) state <= 3'b101;
                else state <= 3'b000;
            3'b101: // S5
                state <= 3'b000;
            default:
                state <= 3'b000;
        endcase
    end
end

// Combinational logic for MATCH signal
assign MATCH = (state == 3'b101)? 1'b1 : 1'b0;

endmodule