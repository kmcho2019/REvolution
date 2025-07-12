module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

// Current state and next state
reg [3:0] state;
reg [3:0] next_state;

// Default output
assign MATCH = (state == S5) ? 1'b1 : 1'b0;

// Combinational logic for next state
always @(*) begin
    case (state)
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
            if (IN) next_state = S1;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Sequential logic for state update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

endmodule