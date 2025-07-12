module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define states
parameter STATE_000 = 3'b000;
parameter STATE_001 = 3'b001;
parameter STATE_010 = 3'b010;
parameter STATE_011 = 3'b011;
parameter STATE_100 = 3'b100;

// Current state
reg [2:0] currentState;

// Next state logic
always @(*) begin
    case(currentState)
        STATE_000: begin
            if (!x) begin
                nextState = STATE_000;
            end else begin
                nextState = STATE_001;
            end
        end
        STATE_001: begin
            if (!x) begin
                nextState = STATE_001;
            end else begin
                nextState = STATE_100;
            end
        end
        STATE_010: begin
            if (!x) begin
                nextState = STATE_010;
            end else begin
                nextState = STATE_001;
            end
        end
        STATE_011: begin
            if (!x) begin
                nextState = STATE_001;
            end else begin
                nextState = STATE_010;
            end
        end
        STATE_100: begin
            if (!x) begin
                nextState = STATE_011;
            end else begin
                nextState = STATE_100;
            end
        end
        default: begin
            nextState = STATE_000;
        end
    endcase
end

// Update current state
always @(posedge clk) begin
    if (reset) begin
        currentState <= STATE_000;
    end else begin
        currentState <= nextState;
    end
end

// Determine output z
always @(*) begin
    case(currentState)
        STATE_000, STATE_001, STATE_010: begin
            z = 0;
        end
        STATE_011, STATE_100: begin
            z = 1;
        end
        default: begin
            z = 0;
        end
    endcase
end

reg [2:0] nextState;

endmodule