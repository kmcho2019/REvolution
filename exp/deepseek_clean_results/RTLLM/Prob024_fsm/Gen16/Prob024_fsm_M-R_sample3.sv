module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// One-hot state definitions
localparam [3:0] IDLE   = 4'b0001;
localparam [3:0] GOT1   = 4'b0010;
localparam [3:0] GOT10  = 4'b0100;
localparam [3:0] GOT100 = 4'b1000;

reg [3:0] current_state;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic with continuous assignments
wire [3:0] next_state;
assign next_state[0] = (~current_state[3] & ~current_state[2] & ~current_state[1] & ~IN) |  // Stay in IDLE
                      (~current_state[3] & ~current_state[2] & current_state[1] & ~IN) |   // GOT1 -> GOT10
                      (~current_state[3] & current_state[2] & ~current_state[1] & ~IN) |  // GOT10 -> GOT100
                      (current_state[3] & ~current_state[2] & ~current_state[1] & ~IN);   // GOT100 -> GOT10

assign next_state[1] = (~current_state[3] & ~current_state[2] & ~current_state[1] & IN) |  // IDLE -> GOT1
                      (~current_state[3] & ~current_state[2] & current_state[1] & IN) |   // GOT1 stay
                      (~current_state[3] & current_state[2] & ~current_state[1] & IN) |   // GOT10 -> GOT1
                      (current_state[3] & ~current_state[2] & ~current_state[1] & IN);    // GOT100 -> GOT1

assign next_state[2] = (~current_state[3] & ~current_state[2] & current_state[1] & ~IN);  // GOT1 -> GOT10
assign next_state[3] = (~current_state[3] & current_state[2] & ~current_state[1] & ~IN);  // GOT10 -> GOT100

// Combinational Mealy output
assign MATCH = (current_state == GOT100) && IN;

endmodule