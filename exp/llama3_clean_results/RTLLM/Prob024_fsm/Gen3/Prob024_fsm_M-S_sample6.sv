module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] state; // State variable to track the sequence

// Sequential logic for state update
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 5'b00000; // Reset state
        MATCH <= 1'b0; // Reset MATCH
    end else begin
        case(state)
            5'b00000: if(IN) state <= 5'b00001; // Start of sequence
            5'b00001: if(!IN) state <= 5'b00010; else state <= 5'b00001; // Second bit
            5'b00010: if(!IN) state <= 5'b00011; else state <= 5'b00001; // Third bit
            5'b00011: if(IN) state <= 5'b00100; else state <= 5'b00001; // Fourth bit
            5'b00100: if(IN) state <= 5'b00101; else state <= 5'b00010; // Fifth bit
            5'b00101: if(IN) state <= 5'b00101; else state <= 5'b00010; // Matched sequence
            default: state <= 5'b00000; // Unknown state
        endcase
        MATCH <= (state == 5'b00101 && IN); // Assert MATCH when sequence is detected
    end
end

endmodule