module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot state encoding
    localparam [7:0]
        S0 = 8'b0000_0001, // 0 consecutive 1's
        S1 = 8'b0000_0010, // 1 consecutive 1
        S2 = 8'b0000_0100, // 2 consecutive 1's
        S3 = 8'b0000_1000, // 3 consecutive 1's
        S4 = 8'b0001_0000, // 4 consecutive 1's
        S5 = 8'b0010_0000, // 5 consecutive 1's
        S6 = 8'b0100_0000, // 6 consecutive 1's
        S7 = 8'b1000_0000; // 7 or more consecutive 1's (error)

    reg [7:0] state, next_state;
    reg disc_next, flag_next, err_next;

    // Combinational logic: next state and outputs based on current state and input
    always @(*) begin
        // Default outputs and next state
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;
        next_state = S0;

        case (state)
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
                if (in) begin
                    next_state = S6;
                    // if in=1 after 5 consecutive 1s, do not discard, keep counting ones
                end else begin
                    next_state = S0;
                    disc_next = 1'b1; // Discard zero after five 1s sequence: "0111110"
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7;
                    // Transition to error state after 6 consecutive 1s plus another 1
                end else begin
                    next_state = S0;
                    flag_next = 1'b1; // Flag detected: "01111110"
                end
            end
            S7: begin
                // Remain in error state if input continues to be 1
                if (in) begin
                    next_state = S7;
                    err_next = 1'b1; // Error asserted for 7+ consecutive 1s
                end else begin
                    next_state = S0;
                    err_next = 1'b1; // Also flag error when input zero after error state
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: state update and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule