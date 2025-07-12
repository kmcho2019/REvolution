module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

reg [3:0] current_state;
reg [3:0] next_state;

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == S5) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

// Combinational logic
always @(*) begin
    case(current_state)
        S0: begin
            if(IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if(!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if(!IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if(IN) begin
                next_state = S4;
            end else begin
                next_state = S1; // Reset to S1 if '1' is seen after '100'
            end
        end
        S4: begin
            if(IN) begin
                next_state = S5;
            end else begin
                next_state = S1; // Reset to S1 if '0' is seen after '1001'
            end
        end
        S5: begin
            if(IN) begin
                next_state = S5; // Stay in S5 if '1' is seen after '10011'
            end else begin
                next_state = S1; // Reset to S1 if '0' is seen after '10011'
            end
        end
        default: next_state = S0;
    endcase
end

endmodule