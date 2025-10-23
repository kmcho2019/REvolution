module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // States: IDLE (0), ONE (1), TWO (2), THREE (3), FOUR (4), FIVE (5), ERROR (6)
    reg [2:0] state;

    // Output assignments
    assign disc = (state == 4 && !in);
    assign flag = (state == 5 && !in);
    assign err = (state == 5 && in) || (state == 6);

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end else begin
            case (state)
                0: state <= in ? 1 : 0;  // Count 1st '1'
                1: state <= in ? 2 : 0;  // Count 2nd '1'
                2: state <= in ? 3 : 0;  // Count 3rd '1'
                3: state <= in ? 4 : 0;  // Count 4th '1'
                4: state <= in ? 5 : 0;  // Count 5th '1'
                5: state <= in ? 6 : 0;  // Count 6th '1' or flag
                6: state <= in ? 6 : 0;  // Stay in error until '0'
                default: state <= 0;
            endcase
        end
    end

endmodule