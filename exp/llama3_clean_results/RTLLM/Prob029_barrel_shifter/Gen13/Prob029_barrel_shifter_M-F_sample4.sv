module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    reg [7:0] temp_out; // Temporary reg variable to hold the intermediate result

    always @(*) begin
        temp_out = in; // Initialize temp_out with the input value
        // Perform shifts based on the control signal
        if (ctrl[2]) temp_out = {in[3:0], in[7:4]}; // Shift by 4
        if (ctrl[1]) temp_out = {temp_out[5:0], temp_out[7:6]}; // Shift by 2
        if (ctrl[0]) temp_out = {temp_out[6:0], temp_out[7]}; // Shift by 1
        out = temp_out; // Assign the final result to the output "out"
    end

endmodule