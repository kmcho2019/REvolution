module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 5'd0;
parameter S1 = 5'd1;
parameter S2 = 5'd2;
parameter S3 = 5'd3;
parameter S4 = 5'd4;
parameter S5 = 5'd5;

reg [4:0] current_state;

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        case(current_state)
            S0: begin
                if(IN)
                    current_state <= S1;
                else
                    current_state <= S0;
                MATCH <= 0;
            end
            S1: begin
                if(!IN)
                    current_state <= S2;
                else
                    current_state <= S1;
                MATCH <= 0;
            end
            S2: begin
                if(!IN)
                    current_state <= S3;
                else
                    current_state <= S1;
                MATCH <= 0;
            end
            S3: begin
                if(IN)
                    current_state <= S4;
                else
                    current_state <= S1;
                MATCH <= 0;
            end
            S4: begin
                if(IN) begin
                    current_state <= S5;
                    MATCH <= 1;
                end else
                    current_state <= S1;
            end
            S5: begin
                if(IN)
                    current_state <= S5;
                else
                    current_state <= S1;
                MATCH <= 0;
            end
            default: begin
                current_state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule