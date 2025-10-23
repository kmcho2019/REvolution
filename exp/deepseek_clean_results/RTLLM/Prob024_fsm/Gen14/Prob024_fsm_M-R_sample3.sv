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
        case (1'b1) // synthesis parallel_case
            current_state[0]: current_state <= IN ? GOT1 : IDLE;
            current_state[1]: current_state <= IN ? GOT1 : GOT10;
            current_state[2]: current_state <= IN ? GOT1 : GOT100;
            current_state[3]: current_state <= IN ? GOT1 : GOT10;
            default: current_state <= IDLE;
        endcase
    end
end

// Mealy output (combinational)
assign MATCH = (current_state == GOT100) & IN;

endmodule