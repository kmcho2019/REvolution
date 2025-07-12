module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // current state
reg [2:0] next_state; // next state
reg match_reg; // registered match signal

// Define states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// State transition logic
always @(*) begin
    case(state)
        S0: begin
            if (IN == 1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (IN == 0) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if (IN == 0) next_state = S3;
            else next_state = S0;
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
            if (IN == 0) next_state = S2;
            else next_state = S0;
            match_reg = 1'b1;
        end
        default: next_state = S0;
    endcase
end

// Output logic
assign MATCH = match_reg;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        match_reg <= 1'b0;
    end
    else begin
        state <= next_state;
        if (state == S5 && IN == 1) match_reg <= 1'b1;
        else match_reg <= 1'b0;
    end
end

endmodule