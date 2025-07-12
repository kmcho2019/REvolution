module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;

reg [3:0] state;
reg [3:0] next_state;

// State transition logic
always @(*) begin
    case (state)
        S0: if (IN) next_state = S1; else next_state = S0;
        S1: if (!IN) next_state = S2; else next_state = S1;
        S2: if (!IN) next_state = S3; else next_state = S1;
        S3: if (IN) next_state = S4; else next_state = S0;
        S4: if (IN) next_state = S5; else next_state = S0;
        S5: if (IN) next_state = S5; else next_state = S0;
        default: next_state = S0;
    endcase
end

// Output logic
always @(*) begin
    if (state == S5 && IN) begin
        MATCH = 1;
    end else begin
        MATCH = 0;
    end
end

// State update and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end

endmodule