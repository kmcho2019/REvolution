module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 6-state machine
reg [2:0] next_state;

// State transition logic using assign statements
assign next_state = (RST)? 3'b000 :
                   (state == 3'b000)? (IN)? 3'b001 : 3'b000 :
                   (state == 3'b001)? (!IN)? 3'b010 : 3'b001 :
                   (state == 3'b010)? (!IN)? 3'b011 : 3'b001 :
                   (state == 3'b011)? (IN)? 3'b100 : 3'b011 :
                   (state == 3'b100)? (IN)? 3'b101 : 3'b000 :
                   (state == 3'b101)? 3'b000 : 3'b000;

// Synchronous reset and state update
always @(posedge CLK) begin
    if (RST) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

// MATCH signal assertion
assign MATCH = (state == 3'b101);

endmodule