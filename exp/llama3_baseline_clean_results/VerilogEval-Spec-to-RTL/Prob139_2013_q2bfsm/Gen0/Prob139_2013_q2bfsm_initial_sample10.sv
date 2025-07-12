module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

// Enum for states
enum logic [2:0] {
    STATE_A, // Reset
    STATE_B, // Set f
    STATE_C, // Monitor x
    STATE_D, // Set g
    STATE_E, // Monitor y
    STATE_F, // g persistent
    STATE_G  // g reset
} state, nextState;

// Counter for monitoring sequences and timeouts
reg [1:0] xSeqCounter;
reg [1:0] yTimeoutCounter;

always_comb begin
    // Default assignments
    f = 0;
    g = 0;
    
    // Next state logic
    case (state)
        STATE_A: begin
            if (~resetn) begin
                nextState = STATE_A;
            end else begin
                nextState = STATE_B;
            end
        end
        STATE_B: begin
            f = 1;
            nextState = STATE_C;
        end
        STATE_C: begin
            if (xSeqCounter == 3'b101) begin
                nextState = STATE_D;
            end else begin
                nextState = STATE_C;
            end
        end
        STATE_D: begin
            g = 1;
            nextState = STATE_E;
        end
        STATE_E: begin
            if (yTimeoutCounter == 2'b10) begin
                if (y) begin
                    nextState = STATE_F;
                end else begin
                    nextState = STATE_G;
                end
            end else begin
                nextState = STATE_E;
            end
        end
        STATE_F: begin
            g = 1;
            nextState = STATE_F;
        end
        STATE_G: begin
            nextState = STATE_G;
        end
        default: begin
            nextState = STATE_A;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        xSeqCounter <= 0;
        yTimeoutCounter <= 0;
    end else begin
        state <= nextState;
        
        // Update x sequence counter
        case (state)
            STATE_C: begin
                if (x) begin
                    xSeqCounter <= {xSeqCounter[0], 1'b1};
                end else begin
                    xSeqCounter <= {xSeqCounter[0], 1'b0};
                end
            end
            default: begin
                xSeqCounter <= 0;
            end
        endcase
        
        // Update y timeout counter
        case (state)
            STATE_E: begin
                yTimeoutCounter <= yTimeoutCounter + 1'b1;
            end
            default: begin
                yTimeoutCounter <= 0;
            end
        endcase
    end
end

endmodule