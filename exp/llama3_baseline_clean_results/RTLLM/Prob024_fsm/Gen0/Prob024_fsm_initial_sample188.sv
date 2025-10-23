module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Current state of the FSM

// Define states
parameter S0 = 3'b000; // Initial state
parameter S1 = 3'b001; // First '1' detected
parameter S2 = 3'b010; // First '0' detected
parameter S3 = 3'b011; // Second '0' detected
parameter S4 = 3'b100; // First '1' in the second part of the sequence detected
parameter S5 = 3'b101; // Second '1' detected, sequence matched

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN) begin
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
        endcase
    end
end

endmodule