module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // 3-bit state register
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0; // Reset state machine
    end else begin
        case(state)
            S0: begin
                if(IN) state <= S1;
                else state <= S0;
            end
            S1: begin
                if(!IN) state <= S2;
                else state <= S0;
            end
            S2: begin
                if(!IN) state <= S3;
                else state <= S0;
            end
            S3: begin
                if(IN) state <= S4;
                else state <= S0;
            end
            S4: begin
                if(IN) state <= S5;
                else state <= S0;
            end
            S5: begin
                if(IN) state <= S5;
                else state <= S0;
            end
        endcase
    end
end

assign MATCH = (state == S5) ? 1'b1 : 1'b0;

endmodule