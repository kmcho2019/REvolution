module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and outputs
            case (state)
                0: state <= in ? 1 : 0;
                1: state <= in ? 2 : 0;
                2: state <= in ? 3 : 0;
                3: state <= in ? 4 : 0;
                4: state <= in ? 5 : 0;
                5: begin
                    state <= in ? 6 : 0;
                    disc <= ~in;  // Discard if next bit is 0
                end
                6: begin
                    state <= in ? 7 : 0;
                    flag <= ~in;  // Flag if next bit is 0
                    err <= in;   // Error if next bit is 1
                end
                7: begin
                    state <= in ? 7 : 0;
                    err <= in;    // Continuous error for more 1s
                end
            endcase
        end
    end

endmodule