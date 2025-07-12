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
            // Clear outputs by default
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and outputs
            case (state)
                0: begin
                    if (in) state <= 1;
                end
                1: begin
                    if (in) state <= 2;
                    else state <= 0;
                end
                2: begin
                    if (in) state <= 3;
                    else state <= 0;
                end
                3: begin
                    if (in) state <= 4;
                    else state <= 0;
                end
                4: begin
                    if (in) state <= 5;
                    else state <= 0;
                end
                5: begin
                    if (in) state <= 6;  // Error state
                    else begin
                        state <= 0;
                        disc <= 1;  // Discard bit after 5 ones
                    end
                end
                6: begin  // Error state
                    if (in) err <= 1;
                    else begin
                        state <= 0;
                        flag <= 1;  // Flag after 6 ones
                    end
                end
            endcase
        end
    end

endmodule