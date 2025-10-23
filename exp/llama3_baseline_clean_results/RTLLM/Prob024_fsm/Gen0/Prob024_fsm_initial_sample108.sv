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

reg [3:0] state;

// Initialize state to S0
initial state = S0;

// Next state logic
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
                if (~IN) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (~IN) begin
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