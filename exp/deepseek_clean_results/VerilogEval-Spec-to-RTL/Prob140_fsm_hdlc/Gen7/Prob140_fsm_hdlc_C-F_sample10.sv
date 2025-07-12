module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg next_err;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Registered outputs (assert for one cycle after detection)
            disc <= (count == 5) && !in;
            flag <= (count == 6) && !in;
            err <= next_err;

            // Counter logic
            if (in) begin
                if (count < 7) count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end

    // Next error detection (combinational)
    always @(*) begin
        next_err = (count >= 6) && in;
    end

endmodule