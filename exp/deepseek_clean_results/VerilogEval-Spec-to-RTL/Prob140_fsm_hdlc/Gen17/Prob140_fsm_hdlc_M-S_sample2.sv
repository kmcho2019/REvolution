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
        end else begin
            if (in) begin
                if (state < 7) state <= state + 1;
            end else begin
                state <= 0;
            end
        end

        // Output logic (Moore style)
        disc <= (state == 5) & ~in;
        flag <= (state == 6) & ~in;
        err <= (state >= 6) & in;
    end

endmodule