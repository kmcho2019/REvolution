module fsm(
    input   IN,
    input   CLK,
    input   RST,
    output  MATCH
);

reg [2:0] state; // State register
reg [2:0] nextState; // Next state register
reg       match_reg; // Register to store the MATCH signal

// Define the states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        S0: begin
            if (IN == 1) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                nextState = S2;
            end else begin
                nextState = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                nextState = S3;
            end else begin
                nextState = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
        end
        S4: begin
            if (IN == 1) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        end
        S5: begin
            if (IN == 1) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        end
        default: nextState = S0;
    endcase
end

// Combinational logic to determine the MATCH signal
always @(*) begin
    if (state == S5 && IN == 1) begin
        match_reg = 1'b1;
    end else begin
        match_reg = 1'b0;
    end
end

// Sequential logic to update the state and MATCH signal
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= nextState;
        MATCH <= match_reg;
    end
end

endmodule