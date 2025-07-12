module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state;

// Reset the state when RST is active
assign MATCH = (state == 3'b101);

// Update the state and output signal
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000;
    end else begin
        case(state)
            3'b000: if(IN) state <= 3'b001;
            3'b001: if(!IN) state <= 3'b010;
            3'b010: if(!IN) state <= 3'b011;
            3'b011: if(IN) state <= 3'b100;
            3'b100: if(IN) state <= 3'b101;
            3'b101: if(!IN) state <= 3'b000;
            default: state <= 3'b000;
        endcase
    end
end

endmodule