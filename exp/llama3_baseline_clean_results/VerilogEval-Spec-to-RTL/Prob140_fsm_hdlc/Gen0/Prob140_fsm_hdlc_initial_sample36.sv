module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

// Output signals
reg disc_reg;
reg flag_reg;
reg err_reg;

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @(*) begin
    // Default values
    disc_reg = 1'b0;
    flag_reg = 1'b0;
    err_reg = 1'b0;
    
    // Compute next state
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
                disc_reg = 1'b1; // Assert discard
            end else begin
                nextState = S0;
            end
        end
        S6: begin
            if (in) begin
                nextState = S7;
            end else begin
                nextState = S0;
                flag_reg = 1'b1; // Assert flag
            end
        end
        S7: begin
            if (in) begin
                nextState = S7;
                err_reg = 1'b1; // Assert error
            end else begin
                nextState = S0;
            end
        end
        default: begin
            nextState = S0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state <= nextState;
    end
end

endmodule