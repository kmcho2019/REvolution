module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: number of consecutive 1's seen after a 0
    // from 0 (no consecutive ones) to 6 (six consecutive ones)
    reg [2:0] state, next_state;

    // Sequential state update and synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Moore outputs)
    always @(*) begin
        // Default outputs
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
            3'd0: begin
                // No consecutive ones so far
                if (in)
                    next_state = 3'd1; // first 1 detected
                else
                    next_state = 3'd0; // stay in 0
            end

            3'd1: begin
                if (in)
                    next_state = 3'd2;
                else
                    next_state = 3'd0;
            end

            3'd2: begin
                if (in)
                    next_state = 3'd3;
                else
                    next_state = 3'd0;
            end

            3'd3: begin
                if (in)
                    next_state = 3'd4;
                else
                    next_state = 3'd0;
            end

            3'd4: begin
                if (in)
                    next_state = 3'd5;
                else
                    next_state = 3'd0;
            end

            3'd5: begin
                if (in)
                    next_state = 3'd6;
                else begin
                    // Saw exactly 5 consecutive 1s then a 0 => discard next bit
                    next_state = 3'd0;
                    disc = 1'b1; // assert disc output for one cycle
                end
            end

            3'd6: begin
                if (in) begin
                    // 7 or more consecutive 1s => error
                    next_state = 3'd6; // stay in error state
                    err = 1'b1;
                end
                else begin
                    // Exactly 6 consecutive 1s followed by 0 => flag detected
                    next_state = 3'd0;
                    flag = 1'b1;
                end
            end

            default: begin
                next_state = 3'd0;
            end
        endcase
    end

endmodule