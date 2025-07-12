module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    S0,
    S1,
    S2,
    S3,
    S4,
    S5
} state_t;

// Current state register
reg [2:0] current_state;
reg [2:0] next_state;

always @(*) begin
    case (current_state)
        S0: next_state = (IN == 1'b1) ? S1 : S0;
        S1: next_state = (IN == 1'b0) ? S2 : S1;
        S2: next_state = (IN == 1'b0) ? S3 : S1;
        S3: next_state = (IN == 1'b1) ? S4 : S1;
        S4: next_state = (IN == 1'b1) ? S5 : S1;
        S5: next_state = (IN == 1'b1) ? S5 : S1;
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S5 && IN == 1'b1) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule