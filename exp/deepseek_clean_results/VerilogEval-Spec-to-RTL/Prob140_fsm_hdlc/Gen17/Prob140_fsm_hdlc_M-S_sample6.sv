module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update counter
            if (in) begin
                if (cnt < 7) cnt <= cnt + 1;
            end else begin
                cnt <= 0;
            end

            // Set outputs for next cycle
            disc <= (cnt == 5) & ~in;
            flag <= (cnt == 6) & ~in;
            err <= (cnt == 6) & in;
        end
    end

endmodule