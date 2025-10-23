module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Explicit state definitions
localparam [1:0]
    S_IDLE   = 2'b00,
    S_GOT1   = 2'b01,
    S_GOT10  = 2'b10,
    S_GOT100 = 2'b11;

reg [1:0] state;

// Combinational output - Mealy style
assign MATCH = (state == S_GOT100) && IN;

// Single always block for state transitions
always @(posedge CLK) begin
    if (RST) begin
        state <= S_IDLE;
    end else begin
        case (state) // synthesis parallel_case
            S_IDLE:   state <= IN ? S_GOT1 : S_IDLE;
            S_GOT1:   state <= IN ? S_GOT1 : S_GOT10;
            S_GOT10:  state <= IN ? S_GOT1 : S_GOT100;
            S_GOT100: state <= IN ? S_GOT1 : S_GOT10;
            default:  state <= S_IDLE;
        endcase
    end
end

endmodule