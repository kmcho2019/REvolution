module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic for next state
always @(*) begin
    case(state)
        3'b000: if(IN) next_state = 3'b001; else next_state = 3'b000;
        3'b001: if(!IN) next_state = 3'b010; else next_state = 3'b001;
        3'b010: if(!IN) next_state = 3'b011; else next_state = 3'b001;
        3'b011: if(IN) next_state = 3'b100; else next_state = 3'b001;
        3'b100: if(IN) next_state = 3'b101; else next_state = 3'b011;
        3'b101: if(IN) next_state = 3'b101; else next_state = 3'b000;
        default: next_state = 3'b000;
    endcase
end

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state = 3'b000;
        MATCH = 1'b0;
    end else begin
        state = next_state;
        MATCH = (state == 3'b101);
    end
end

endmodule