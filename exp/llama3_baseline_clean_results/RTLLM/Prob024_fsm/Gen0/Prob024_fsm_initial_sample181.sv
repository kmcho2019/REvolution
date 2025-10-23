module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State register

// State encoding
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // After detecting the first 1
localparam S2 = 3'b010; // After detecting the first 0
localparam S3 = 3'b011; // After detecting the second 0
localparam S4 = 3'b100; // After detecting the first 1 in the last two 1s
localparam S5 = 3'b101; // After detecting the second 1

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 1'b0;
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                    MATCH <= 1'b0;
                end else begin
                    state <= S1;
                    MATCH <= 1'b0;
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                    MATCH <= 1'b0;
                end else begin
                    state <= S1;
                    MATCH <= 1'b0;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                    MATCH <= 1'b0;
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1'b1;
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            S5: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 1'b0;
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= S0;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule