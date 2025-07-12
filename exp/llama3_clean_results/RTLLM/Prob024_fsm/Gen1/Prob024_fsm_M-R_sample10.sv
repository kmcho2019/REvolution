module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH // Declare MATCH as a reg for procedural assignment
);

reg [2:0] state; // State register

// Initialize state to S0 (3'b000) at reset
initial state = 3'b000;

// Next state logic
always_comb begin
    case (state)
        3'b000: state = IN ? 3'b001 : 3'b000; // S0
        3'b001: state = IN ? 3'b001 : 3'b010; // S1
        3'b010: state = IN ? 3'b001 : 3'b011; // S2
        3'b011: state = IN ? 3'b100 : 3'b001; // S3
        3'b100: state = IN ? 3'b101 : 3'b001; // S4
        3'b101: state = IN ? 3'b101 : 3'b001; // S5
        default: state = 3'b000;
    endcase
end

// State update and output logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 0;
    end else begin
        state <= state; // No need to update state here, it's updated in always_comb
        MATCH <= (state == 3'b101 && IN); // Set MATCH based on current state and IN
    end
end

endmodule