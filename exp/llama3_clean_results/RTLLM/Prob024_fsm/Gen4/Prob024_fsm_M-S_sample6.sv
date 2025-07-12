module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [3:0] state; // State variable to track the sequence

// Sequential logic for state update
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 4'b0000; // Reset state
        MATCH <= 1'b0; // Reset MATCH
    end else begin
        case(state)
            4'b0000: if(IN) state <= 4'b0001;
            4'b0001: if(!IN) state <= 4'b0010;
            4'b0010: if(!IN) state <= 4'b0011;
            4'b0011: if(IN) state <= 4'b0100;
            4'b0100: if(IN) state <= 4'b0100; else state <= 4'b0010;
            default: state <= 4'b0000; // Unknown state
        endcase
        MATCH <= (state == 4'b0100 && IN); // Assert MATCH when sequence is detected
    end
end

endmodule