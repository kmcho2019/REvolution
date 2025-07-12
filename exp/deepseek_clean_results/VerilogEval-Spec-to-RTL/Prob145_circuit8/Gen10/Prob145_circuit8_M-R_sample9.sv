module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// Define states
localparam IDLE = 2'b00;
localparam P_ACTIVE = 2'b01;
localparam Q_ACTIVE = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(posedge clock) begin
    state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = (a) ? P_ACTIVE : IDLE;
        P_ACTIVE: next_state = (a) ? P_ACTIVE : Q_ACTIVE;
        Q_ACTIVE: next_state = (a) ? IDLE : Q_ACTIVE;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(*) begin
    p = (state == P_ACTIVE);
    q = (state == Q_ACTIVE) || (state == P_ACTIVE && q);
end

endmodule