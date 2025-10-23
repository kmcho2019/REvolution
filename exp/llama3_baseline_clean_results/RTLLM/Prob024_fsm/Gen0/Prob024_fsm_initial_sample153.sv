module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states
localparam S0 = 5'd0;
localparam S1 = 5'd1;
localparam S2 = 5'd2;
localparam S3 = 5'd3;
localparam S4 = 5'd4;
localparam S5 = 5'd5;

// Current state register
reg [4:0] current_state;

// Initialize the current state to S0
initial current_state = S0;

// Output MATCH
reg MATCH_reg;
assign MATCH = MATCH_reg;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the current state to S0
        current_state <= S0;
        // Reset the MATCH signal to 0
        MATCH_reg <= 1'd0;
    end else begin
        case (current_state)
            S0: begin
                if (IN == 1'd1) begin
                    // Transition to S1
                    current_state <= S1;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end else begin
                    // Stay in S0
                    current_state <= S0;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end
            end
            S1: begin
                if (IN == 1'd0) begin
                    // Transition to S2
                    current_state <= S2;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end else if (IN == 1'd1) begin
                    // Transition back to S1
                    current_state <= S1;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end
            end
            S2: begin
                if (IN == 1'd0) begin
                    // Transition to S3
                    current_state <= S3;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end else if (IN == 1'd1) begin
                    // Transition back to S1
                    current_state <= S1;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end
            end
            S3: begin
                if (IN == 1'd1) begin
                    // Transition to S4
                    current_state <= S4;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end else if (IN == 1'd0) begin
                    // Transition back to S0
                    current_state <= S0;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end
            end
            S4: begin
                if (IN == 1'd1) begin
                    // Transition to S5
                    current_state <= S5;
                    // MATCH = 1
                    MATCH_reg <= 1'd1;
                end else if (IN == 1'd0) begin
                    // Transition back to S0
                    current_state <= S0;
                    // MATCH remains 0
                    MATCH_reg <= 1'd0;
                end
            end
            S5: begin
                // Stay in S5 or transition back to S0
                if (IN == 1'd1) begin
                    current_state <= S5;
                    MATCH_reg <= 1'd1;
                end else begin
                    current_state <= S0;
                    MATCH_reg <= 1'd0;
                end
            end
            default: begin
                // Default case: stay in S0
                current_state <= S0;
                MATCH_reg <= 1'd0;
            end
        endcase
    end
end

endmodule