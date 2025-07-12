module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output logic [7:0] out   // 8-bit shifted output
);

    // Use temporary variables to store the intermediate results
    logic [7:0] temp;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    always @(*) begin
        if (ctrl[2]) begin
            temp = {in[3:0], 4'b0000}; // Shift by 4 positions
        end else begin
            temp = in; // No shift
        end
    end

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    logic [7:0] temp2;
    always @(*) begin
        if (ctrl[1]) begin
            temp2 = {temp[5:0], 2'b00}; // Shift by 2 positions
        end else begin
            temp2 = temp; // No shift
        end
    end

    // Stage 3: Shift by 1 position if ctrl[0] is high
    always @(*) begin
        if (ctrl[0]) begin
            out = {temp2[6:0], temp2[7]}; // Shift by 1 position
        end else begin
            out = temp2; // No shift
        end
    end

endmodule