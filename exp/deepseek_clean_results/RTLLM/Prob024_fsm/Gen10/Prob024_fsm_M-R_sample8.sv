module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state;

// Next state logic using continuous assignments
wire [1:0] next_state = 
    (state == IDLE)  ? (IN ? S1     : IDLE) :
    (state == S1)    ? (IN ? S1     : S10)  :
    (state == S10)   ? (IN ? S1     : S100) :
    (state == S100)  ? (IN ? S1     : IDLE) :
                       IDLE; // default case

// Mealy output (combinational)
assign MATCH = (state == S100) && IN;

// State register
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule