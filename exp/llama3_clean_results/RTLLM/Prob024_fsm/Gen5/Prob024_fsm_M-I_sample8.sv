module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] state; // State variable to track the sequence using one-hot encoding

// Sequential logic for state update
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 5'b00001; // Reset state
        MATCH <= 1'b0; // Reset MATCH
    end else begin
        case(state)
            5'b00001: if(IN) state <= 5'b00010;
            5'b00010: if(!IN) state <= 5'b00100;
            5'b00100: if(!IN) state <= 5'b01000;
            5'b01000: if(IN) state <= 5'b10000;
            5'b10000: if(IN) state <= 5'b10000; else state <= 5'b00100;
            default: state <= 5'b00001; // Unknown state
        endcase
        MATCH <= (state == 5'b10000 && IN); // Assert MATCH when sequence is detected
    end
end

endmodule