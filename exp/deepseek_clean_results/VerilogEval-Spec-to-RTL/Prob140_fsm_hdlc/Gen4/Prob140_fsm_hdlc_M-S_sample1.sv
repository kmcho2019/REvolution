module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state; // [1:0] = 1s count (0-2), [2] = error flag
    reg [1:0] count; // tracks 1s beyond state (0-5 total)

    // Combinational outputs
    assign disc = (count == 2'd2 && state[1:0] == 2'd2 && !in && !state[2]);
    assign flag = (count == 2'd2 && state[1:0] == 2'd2 && in && !state[2]);
    assign err = state[2];

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            count <= 0;
        end else begin
            if (state[2]) begin
                // Stay in error until 0 received
                if (!in) state[2] <= 0;
            end else if (in) begin
                // Count consecutive 1s
                if (count == 2'd2) begin
                    if (state[1:0] == 2'd2) begin
                        // Reached 6 ones
                        state[2] <= 1; // error
                    end else begin
                        state[1:0] <= state[1:0] + 1;
                        count <= 0;
                    end
                end else begin
                    count <= count + 1;
                end
            end else begin
                // Reset counters on 0
                state[1:0] <= 0;
                count <= 0;
            end
        end
    end

endmodule