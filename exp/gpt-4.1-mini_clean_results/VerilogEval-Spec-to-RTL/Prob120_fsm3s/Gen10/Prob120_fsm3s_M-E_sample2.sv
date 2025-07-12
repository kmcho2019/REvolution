module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding: each bit corresponds to one state
    localparam [3:0] 
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic using one-hot states
    always @(*) begin
        // Default to no state active (safe default)
        next_state = 4'b0000;

        if (state == A) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end
        else if (state == B) begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end
        else if (state == C) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = D;
        end
        else if (state == D) begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end
        else begin
            // Defensive fallback: reset to A if in invalid state
            next_state = A;
        end
    end

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output depends solely on being in state D
    assign out = (state == D);

endmodule