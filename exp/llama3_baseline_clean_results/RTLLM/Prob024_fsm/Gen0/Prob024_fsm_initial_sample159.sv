module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Using 3 bits to represent 6 states (S0 to S5)
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN == 1) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (IN == 0) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (IN == 0) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S3;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN == 1) begin
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= S2;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN == 1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S2;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN == 1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S2;
                    MATCH <= 0;
                end
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule