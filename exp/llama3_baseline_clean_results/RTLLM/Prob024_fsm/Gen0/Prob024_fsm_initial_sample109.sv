module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter S0 = 4'd0, 
           S1 = 4'd1, 
           S2 = 4'd2, 
           S3 = 4'd3, 
           S4 = 4'd4, 
           S5 = 4'd5;

reg [3:0] current_state;
reg [3:0] next_state;

// Output logic
assign MATCH = (current_state == S5 && IN == 1)? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(current_state)
        S0: begin
            if(IN == 1'b1) 
                next_state = S1;
            else 
                next_state = S0;
        end
        S1: begin
            if(IN == 1'b0) 
                next_state = S2;
            else 
                next_state = S1;
        end
        S2: begin
            if(IN == 1'b0) 
                next_state = S3;
            else 
                next_state = S1;
        end
        S3: begin
            if(IN == 1'b1) 
                next_state = S4;
            else 
                next_state = S0;
        end
        S4: begin
            if(IN == 1'b1) 
                next_state = S5;
            else 
                next_state = S0;
        end
        S5: begin
            if(IN == 1'b1) 
                next_state = S5;
            else 
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// State register
always @(posedge CLK or posedge RST) begin
    if(RST) 
        current_state <= S0;
    else 
        current_state <= next_state;
end

endmodule