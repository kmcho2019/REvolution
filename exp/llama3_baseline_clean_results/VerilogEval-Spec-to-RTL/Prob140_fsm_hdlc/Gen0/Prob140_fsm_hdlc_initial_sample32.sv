module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Current state of the FSM
reg [2:0] nextState; // Next state of the FSM

// Output signals
reg disc_reg;
reg flag_reg;
reg err_reg;

// State definitions
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

always @(*) begin
    // Default values for output signals
    disc_reg = 1'b0;
    flag_reg = 1'b0;
    err_reg = 1'b0;

    // Determine next state
    case (state)
        S0: begin
            if (in) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (in) begin
                nextState = S2;
            end else begin
                nextState = S0;
            end
        end
        S2: begin
            if (in) begin
                nextState = S3;
            end else begin
                nextState = S0;
            end
        end
        S3: begin
            if (in) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
        end
        S4: begin
            if (in) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        end
        S5: begin
            if (in) begin
                nextState = S6;
            end else begin
                // Inserted zero after 5 consecutive 1s, discard this bit
                disc_reg = 1'b1;
                nextState = S0;
            end
        end
        S6: begin
            if (in) begin
                nextState = S7;
            end else begin
                // Flag detected
                flag_reg = 1'b1;
                nextState = S0;
            end
        end
        S7: begin
            if (in) begin
                nextState = S7;
            end else begin
                nextState = S0;
            end
            // Error condition, 7 or more consecutive 1s
            err_reg = 1'b1;
        end
        default: begin
            nextState = S0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule