module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

// State encoding: number of consecutive 1's seen (0 to 6)
localparam S0 = 3'd0; // 0 consecutive 1's
localparam S1 = 3'd1; // 1 consecutive 1's
localparam S2 = 3'd2; // 2 consecutive 1's
localparam S3 = 3'd3; // 3 consecutive 1's
localparam S4 = 3'd4; // 4 consecutive 1's
localparam S5 = 3'd5; // 5 consecutive 1's
localparam S6 = 3'd6; // 6 consecutive 1's

reg [2:0] state, next_state;

// Moore outputs depend only on state and input (to be stored in next outputs)
reg next_disc, next_flag, next_err;

always @(*) begin
    // Default outputs
    next_disc = 0;
    next_flag = 0;
    next_err  = 0;

    case (state)
        S0: begin
            if (in == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (in == 1'b1)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (in == 1'b1)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (in == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (in == 1'b1)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            if (in == 1'b1)
                next_state = S6;
            else begin
                // After 5 consecutive 1's, if zero appears, discard this zero (bit-stuff)
                next_state = S0;
                next_disc = 1'b1;
            end
        end
        S6: begin
            if (in == 1'b1) begin
                // 7 consecutive ones: error
                next_state = S6;
                next_err = 1'b1;
            end else begin
                // 6 consecutive ones followed by zero: flag
                next_state = S0;
                next_flag = 1'b1;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Sequential logic, synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        state <= next_state;
        // Outputs asserted for one cycle after detection
        disc <= next_disc;
        flag <= next_flag;
        err  <= next_err;
    end
end

endmodule