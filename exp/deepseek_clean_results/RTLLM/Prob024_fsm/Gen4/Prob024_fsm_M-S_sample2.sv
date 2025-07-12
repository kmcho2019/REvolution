module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Simplified state encoding
parameter S0 = 2'b00;  // Initial state
parameter S1 = 2'b01;  // Received '1'
parameter S2 = 2'b10;  // Received '100'

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        case (state)
            S0: state <= IN ? S1 : S0;
            S1: state <= IN ? S1 : (IN ? S1 : S2);  // On '0', move to S2
            S2: begin
                if (IN) state <= S1;  // After '100', next '1' starts new sequence
                else state <= S0;      // Wrong input resets
            end
        endcase
    end
end

// Output logic - MATCH=1 when we have "100" and get "11"
always @(*) begin
    MATCH = (state == S2) && IN;
end

endmodule