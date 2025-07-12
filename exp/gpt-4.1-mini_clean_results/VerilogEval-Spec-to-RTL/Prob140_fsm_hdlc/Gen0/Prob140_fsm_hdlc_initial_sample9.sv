module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

// State encoding
localparam S0    = 4'd0; // No consecutive ones yet (last bit 0)
localparam S1    = 4'd1; // 1 consecutive one
localparam S2    = 4'd2; // 2 consecutive ones
localparam S3    = 4'd3; // 3 consecutive ones
localparam S4    = 4'd4; // 4 consecutive ones
localparam S5    = 4'd5; // 5 consecutive ones
localparam S6    = 4'd6; // 6 consecutive ones
localparam SFLAG = 4'd7; // Assert flag output (one cycle)
localparam SDISC = 4'd8; // Assert disc output (one cycle)
localparam SERR  = 4'd9; // Assert err output (one cycle)

reg [3:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    // default next state is current state
    next_state = state;
    case(state)
        S0: begin
            if (in)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (in)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (in)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (in)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (in)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            if (~in) 
                // Detected 5 ones then 0 => bit to discard on next cycle
                next_state = SDISC;
            else 
                // got 6 consecutive ones, wait next bit to decide flag or err
                next_state = S6;
        end
        S6: begin
            if (~in)
                // 6 ones then 0: flag detected
                next_state = SFLAG;
            else
                // 7 or more ones: error detected
                next_state = SERR;
        end
        SDISC: begin
            // output disc asserted for 1 cycle, then back to S0 with last bit=0
            if (in)
                next_state = S1;
            else
                next_state = S0;
        end
        SFLAG: begin
            // output flag asserted for 1 cycle, then back to S0 with last bit=0
            if (in)
                next_state = S1;
            else
                next_state = S0;
        end
        SERR: begin
            // output err asserted for 1 cycle, stay in error checking state until reset or a 0 seen?
            // Spec doesn't say explicitly, so after err output, continue decoding
            // We'll return to S0 or S1 depending on input after error cycle
            if (in)
                next_state = S1;
            else
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic (Moore outputs)
always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
        case(state)
            SDISC: disc <= 1'b1;
            SFLAG: flag <= 1'b1;
            SERR:  err  <= 1'b1;
            default: begin
                // no output asserted
                disc <= 1'b0;
                flag <= 1'b0;
                err  <= 1'b0;
            end
        endcase
    end
end

endmodule