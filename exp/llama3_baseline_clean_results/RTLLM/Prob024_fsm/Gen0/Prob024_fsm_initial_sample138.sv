module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM
reg match_reg; // Registered output

// Define the states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// Combinational logic for next state and output
always @(*) begin
    case (state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
            match_reg = 0;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
            match_reg = 0;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
            match_reg = 0;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S0;
            match_reg = 0;
        end
        S4: begin
            if (IN) next_state = S5;
            else next_state = S0;
            match_reg = 0;
        end
        S5: begin
            if (IN) begin
                next_state = S5;
                match_reg = 1;
            end
            else next_state = S0;
            match_reg = 0;
        end
        default: begin
            next_state = S0;
            match_reg = 0;
        end
    endcase
end

// Sequential logic for state register and output register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end
    else begin
        state <= next_state;
        MATCH <= match_reg;
    end
end

endmodule