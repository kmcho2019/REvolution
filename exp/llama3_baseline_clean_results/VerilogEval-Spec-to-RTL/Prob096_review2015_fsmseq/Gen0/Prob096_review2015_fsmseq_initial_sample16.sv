module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state
reg start_shifting_reg; // Internal register for start_shifting

// Define states
localparam S0 = 3'b000; // Idle state
localparam S1 = 3'b001; // Matched '1'
localparam S2 = 3'b010; // Matched '11'
localparam S3 = 3'b011; // Matched '110'
localparam S4 = 3'b100; // Matched '1101'
localparam S5 = 3'b101; // Final state

// State transition logic
always @(*) begin
    case(state)
        S0: begin
            if (data == 1) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (data == 1) begin
                nextState = S2;
            end else if (data == 0) begin
                nextState = S3;
            end else begin
                nextState = S1; // Should not happen, but just in case
            end
        end
        S2: begin
            if (data == 0) begin
                nextState = S4;
            end else begin
                nextState = S2; // Should not happen, but just in case
            end
        end
        S3: begin
            if (data == 1) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S4: begin
            nextState = S5;
        end
        S5: begin
            nextState = S5; // Stay in final state
        end
        default: begin
            nextState = S0; // Should not happen, but just in case
        end
    endcase
end

// Reset logic
always @(posedge clk) begin
    if (reset == 1) begin
        state <= S0;
        start_shifting_reg <= 0;
    end else begin
        state <= nextState;
        if (state == S5) begin
            start_shifting_reg <= 1;
        end else if (state == S0) begin
            start_shifting_reg <= 0;
        end
    end
end

// Output logic
assign start_shifting = start_shifting_reg;

// Initial state
initial begin
    state = S0;
    start_shifting_reg = 0;
end

endmodule