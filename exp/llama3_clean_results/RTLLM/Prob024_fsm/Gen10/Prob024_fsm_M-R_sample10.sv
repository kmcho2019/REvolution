module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

typedef enum {S0, S1, S2, S3, S4, S5} state;
reg [2:0] current_state;

// State machine logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        current_state <= S0; // Reset state machine
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        case(current_state)
            S0: begin
                if(IN == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= S0;
                end
            end
            S1: begin
                if(IN == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= S0;
                end
            end
            S2: begin
                if(IN == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= S0;
                end
            end
            S3: begin
                if(IN == 1'b1) begin
                    current_state <= S4;
                end else begin
                    current_state <= S0;
                end
            end
            S4: begin
                if(IN == 1'b1) begin
                    current_state <= S5;
                    MATCH <= 1'b1; // Assert MATCH signal
                end else begin
                    current_state <= S0;
                end
            end
            S5: begin
                current_state <= S0;
                MATCH <= 1'b0; // Deassert MATCH signal
            end
        endcase
    end
end

endmodule