module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output reg [7:0] out
);

    always @(*) begin
        out = in; // Initialize out with the input value
        // Perform shifts based on the control signal
        if (ctrl[2]) out = {in[3:0], in[7:4]}; // Shift by 4
        if (ctrl[1]) out = {out[5:0], out[7:6]}; // Shift by 2
        if (ctrl[0]) out = {out[6:0], out[7]}; // Shift by 1
    end

endmodule