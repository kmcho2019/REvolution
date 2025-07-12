module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the state machine
enum logic [1:0] {
    AboveS2 = 2'b00,
    BetweenS2AndS1 = 2'b01,
    BetweenS1AndS0 = 2'b10,
    BelowS0 = 2'b11
} currentState, nextState;

// Define the next state logic based on the current sensor inputs
always @(*) begin
    if (s[2]) begin
        nextState = AboveS2;
    end else if (s[1]) begin
        nextState = BetweenS2AndS1;
    end else if (s[0]) begin
        nextState = BetweenS1AndS0;
    end else begin
        nextState = BelowS0;
    end
end

// Define the state machine's sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state machine to the BelowS0 state
        currentState <= BelowS0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update the current state
        currentState <= nextState;
        
        // Determine the output values based on the current state
        case (currentState)
            AboveS2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                // dfr should be deasserted when the water level is above s[2]
                dfr <= 1'b0;
            end
            BetweenS2AndS1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                // Determine if the water level is rising
                if (nextState == BetweenS1AndS0 || nextState == BelowS0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            BetweenS1AndS0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                // Determine if the water level is rising
                if (nextState == BelowS0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            BelowS0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                // dfr should be deasserted when the water level is below s[0]
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule