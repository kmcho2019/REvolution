module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding - count of consecutive 1s (0-6) plus error state (7)
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            {disc, flag, err} <= 3'b0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and output assignments
            case (state)
                0: state <= in ? 1 : 0;  // Count 1s
                1: state <= in ? 2 : 0;
                2: state <= in ? 3 : 0;
                3: state <= in ? 4 : 0;
                4: state <= in ? 5 : 0;
                5: begin
                    if (in) state <= 6;
                    else disc <= 1;
                end
                6: begin
                    if (in) state <= 7;
                    else flag <= 1;
                end
                7: begin
                    err <= in;
                    if (!in) state <= 0;
                end
            endcase
        end
    end

endmodule