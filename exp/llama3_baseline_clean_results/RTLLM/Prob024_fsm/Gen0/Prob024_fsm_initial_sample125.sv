module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // State register
reg [2:0] next_state; // Next state register
reg match_reg; // Register for MATCH output

// Define states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

// Combinational logic for next state and output
always @(*) begin
    case (state)
        S0: begin
            if (IN) begin
                next_state = S1;
                match_reg = 0;
            end
            else begin
                next_state = S0;
                match_reg = 0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
                match_reg = 0;
            end
            else begin
                next_state = S1;
                match_reg = 0;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
                match_reg = 0;
            end
            else begin
                next_state = S1;
                match_reg = 0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                match_reg = 0;
            end
            else begin
                next_state = S1;
                match_reg = 0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                match_reg = 1;
            end
            else begin
                next_state = S1;
                match_reg = 0;
            end
        end
        S5: begin
            next_state = S1;
            match_reg = 1;
        end
        default: begin
            next_state = S0;
            match_reg = 0;
        end
    endcase
end

// Sequential logic for state and output
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