module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State register to store the current state

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // Synchronous reset
        state <= S0; // Reset to initial state
        MATCH <= 0; // Reset MATCH signal
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
                MATCH <= 0;
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
                MATCH <= 0;
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
                MATCH <= 0;
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= S1;
                end
                MATCH <= 0;
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1; // Set MATCH signal to 1
                end else begin
                    state <= S1;
                end
            end
            S5: begin
                if (IN) begin
                    state <= S5;
                end else begin
                    state <= S1;
                end
                MATCH <= 0;
            end
        endcase
    end
end

endmodule