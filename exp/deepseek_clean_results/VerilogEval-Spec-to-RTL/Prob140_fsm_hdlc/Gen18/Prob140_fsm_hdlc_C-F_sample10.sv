module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;

    // State definitions for clarity (not strictly necessary)
    localparam IDLE = 3'd0;
    localparam CNT1 = 3'd1;
    localparam CNT2 = 3'd2;
    localparam CNT3 = 3'd3;
    localparam CNT4 = 3'd4;
    localparam CNT5 = 3'd5;
    localparam FLAG_OR_ERR = 3'd6;

    always @(posedge clk) begin
        if (reset) begin
            count <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update counter
            if (in) begin
                if (count < FLAG_OR_ERR) count <= count + 1;
            end else begin
                count <= IDLE;
            end

            // Set outputs for next cycle
            disc <= (count == CNT5) && !in;
            flag <= (count == FLAG_OR_ERR) && !in;
            err <= (count == FLAG_OR_ERR) && in;
        end
    end

endmodule