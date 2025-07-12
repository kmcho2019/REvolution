module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State register
reg [4:0] state;

// Initialize state to idle (0)
initial state = 5'b00000;

// Next state logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        case (1'b1)
            state[0] && IN: state <= 5'b00010; // 1 -> 10
            state[1] && ~IN: state <= 5'b00100; // 10 -> 100
            state[2] && ~IN: state <= 5'b01000; // 100 -> 1000
            state[3] && IN: state <= 5'b10000; // 1000 -> 10000
            state[4] && IN: state <= 5'b10000; MATCH <= 1'b1; // 10000 -> 10000 (match)
            default: begin
                if (IN) state <= 5'b00010; // 0 -> 10
                else state <= 5'b00000; // reset
            end
        endcase
        if (!(state == 5'b10000 && IN)) MATCH <= 1'b0;
    end
end

endmodule