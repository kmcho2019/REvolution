module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Directly calculate the shifted output based on the control signal
    assign out = (ctrl[2] ? {in[3:0], in[7:4]} : in) &
                 (ctrl[1] ? {in[5:0], in[7:6]} : out) &
                 (ctrl[0] ? {in[6:0], in[7]} : out);

    // However, the direct calculation needs to properly account for the sequential nature of the shifts.
    // A more accurate approach involves understanding that each bit in the output is determined by a specific bit in the input,
    // shifted according to the control signal. Thus, we can directly assign each output bit based on its position and the shift amount.

    // A more correct and simplified implementation considering the above would actually look like this:
    always @(*) begin
        out = in;
        if (ctrl[2]) out = {in[3:0], in[7:4]}; // Shift by 4
        if (ctrl[1]) out = {out[5:0], out[7:6]}; // Shift by 2
        if (ctrl[0]) out = {out[6:0], out[7]}; // Shift by 1
    end

endmodule