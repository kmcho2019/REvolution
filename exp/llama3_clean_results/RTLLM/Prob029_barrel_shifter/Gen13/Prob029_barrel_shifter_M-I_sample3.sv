module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    reg [7:0] temp; // Temporary variable to hold intermediate results

    always @(*) begin
        temp = in; // Initialize temp with the input

        // Shift by 4 positions if ctrl[2] is high
        if (ctrl[2]) begin
            temp = {temp[3:0], temp[7:4]};
        end

        // Shift by 2 positions if ctrl[1] is high
        if (ctrl[1]) begin
            temp = {temp[5:0], temp[7:6]};
        end

        // Shift by 1 position if ctrl[0] is high
        if (ctrl[0]) begin
            temp = {temp[6:0], temp[7]};
        end

        // Assign the final result to out
        out = temp;
    end

endmodule