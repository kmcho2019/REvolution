module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
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

// Output signal
assign MATCH = (state == S5) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(state)
        S0: begin
            if(IN == 1'b1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if(IN == 1'b0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if(IN == 1'b0) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if(IN == 1'b1) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if(IN == 1'b1) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if(IN == 1'b1) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// State register
always @(posedge CLK or posedge RST) begin
    if(RST) state <= S0;
    else state <= next_state;
end

endmodule