module fsm(
    input  IN,  // Input signal to the FSM
    input  CLK, // Clock signal used for synchronous operation
    input  RST, // Reset signal to initialize the FSM
    output MATCH  // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state; // Current state of the FSM (3 bits for 6 states)
reg match_reg;   // Registered output of the MATCH signal

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // State after receiving '1'
localparam S2 = 3'b010; // State after receiving '0' after '1'
localparam S3 = 3'b011; // State after receiving '0' after '0'
localparam S4 = 3'b100; // State after receiving '1' after '0' '0'
localparam S5 = 3'b101; // State after receiving '1' after '1'

// Initialize the state and MATCH signal
initial begin
    state = S0;
    match_reg = 1'b0;
end

// State machine transitions and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        match_reg <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
                match_reg <= 1'b0;
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
                match_reg <= 1'b0;
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
                match_reg <= 1'b0;
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= S0;
                end
                match_reg <= 1'b0;
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    match_reg <= IN;
                end else begin
                    state <= S0;
                end
            end
            S5: begin
                if (IN) begin
                    match_reg <= IN;
                end
                if (IN) begin
                    state <= S5;
                end else begin
                    state <= S0;
                end
            end
            default: begin
                state <= S0;
                match_reg <= 1'b0;
            end
        endcase
    end
end

assign MATCH = match_reg;

endmodule