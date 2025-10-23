module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state
reg [2:0] next_state; // Next state
reg match_reg; // Registered match signal

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// State transition logic
always @(*) begin
    case (state)
        S0: begin
            if (IN == 1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (IN == 0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (IN == 0) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN == 1) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (IN == 1) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN == 1) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        S5: match_reg = (IN == 1) ? 1'b1 : 1'b0;
        default: match_reg = 1'b0;
    endcase
end

// Register the state and match signal
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_reg;
    end
end

endmodule