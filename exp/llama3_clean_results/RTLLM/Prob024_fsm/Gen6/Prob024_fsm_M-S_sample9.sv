module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
reg [3:0] state;
reg [3:0] next_state;

// Combinational logic for next state
always @(*) begin
    case(state)
        4'b0000: if(IN) next_state = 4'b0001; else next_state = 4'b0000;
        4'b0001: if(!IN) next_state = 4'b0010; else next_state = 4'b0001;
        4'b0010: if(!IN) next_state = 4'b0011; else next_state = 4'b0001;
        4'b0011: if(IN) next_state = 4'b0100; else next_state = 4'b0001;
        4'b0100: if(IN) next_state = 4'b0100; else next_state = 4'b0010;
        default: next_state = 4'b0000;
    endcase
end

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state = 4'b0000;
        MATCH = 1'b0;
    end else begin
        state = next_state;
        MATCH = (state == 4'b0100);
    end
end

endmodule