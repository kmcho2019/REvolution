module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM
reg match; // Output signal MATCH

// Define the states of the FSM
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

// State transition logic
always @(*) begin
    case (state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            next_state = S0;
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        S5: begin
            if (IN == 1) begin
                match = 1'b1;
            end else begin
                match = 1'b0;
            end
        end
        default: begin
            match = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST == 1'b1) begin
        state <= S0;
        match <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match;
    end
end

endmodule