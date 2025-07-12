module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // state register
reg [2:0] next_state; // next state register
reg match_reg; // MATCH output register

// Define states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

// State transition logic
always @(*) begin
    case(state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic
assign MATCH = (state == S5);

// State and output register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        match_reg <= 0;
    end else begin
        state <= next_state;
        match_reg <= (state == S5);
    end
end

endmodule