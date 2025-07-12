module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State variable with 3 bits to represent 6 states

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset to initial state
        MATCH <= 0; // Reset MATCH signal
    end else begin
        case (state)
            S0: begin
                if (IN == 1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
                MATCH <= 0;
            end
            S1: begin
                if (IN == 0) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
                MATCH <= 0;
            end
            S2: begin
                if (IN == 0) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
                MATCH <= 0;
            end
            S3: begin
                if (IN == 1) begin
                    state <= S4;
                end else begin
                    state <= S0;
                end
                MATCH <= 0;
            end
            S4: begin
                if (IN == 1) begin
                    state <= S5;
                end else begin
                    state <= S0;
                end
                MATCH <= 0;
            end
            S5: begin
                if (IN == 1) begin
                    MATCH <= 1; // Set MATCH signal to 1
                end else begin
                    MATCH <= 0;
                end
                state <= S0; // Reset to initial state
            end
            default: begin
                state <= S0; // Default to initial state
                MATCH <= 0;
            end
        endcase
    end
end

endmodule