module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] count, count_next;

    always @(*) begin
        // Next count logic: saturate at 7 on continuous ones
        case (count)
            3'd0: count_next = in ? 3'd1 : 3'd0;
            3'd1: count_next = in ? 3'd2 : 3'd0;
            3'd2: count_next = in ? 3'd3 : 3'd0;
            3'd3: count_next = in ? 3'd4 : 3'd0;
            3'd4: count_next = in ? 3'd5 : 3'd0;
            3'd5: count_next = in ? 3'd6 : 3'd0;
            3'd6: count_next = in ? 3'd7 : 3'd0;
            default: count_next = in ? 3'd7 : 3'd0; // count=7 saturation
        endcase
    end

    // Pipeline registers to hold previous count and input to generate outputs next cycle
    reg [2:0] count_d;
    reg       in_d;

    always @(posedge clk) begin
        if (reset) begin
            count  <= 3'd0;
            count_d <= 3'd0;
            in_d   <= 1'b0;
            disc   <= 1'b0;
            flag   <= 1'b0;
            err    <= 1'b0;
        end else begin
            count <= count_next;

            // pipeline stage for previous count and input
            count_d <= count;
            in_d   <= in;

            // Outputs are asserted one cycle after detection (Moore)
            disc <= (count_d == 3'd5) && !in_d;    // zero after five ones
            flag <= (count_d == 3'd6) && !in_d;    // six ones then zero (flag)
            err  <= (in_d && count_d >= 3'd6);     // seven or more ones
        end
    end

endmodule