module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);
    // Initialize the 2D shift array
    reg [7:0] shift_array [7:0];

    // Populate the shift array
    integer i;
    always @(*) begin
        for (i = 0; i <= 7; i++) begin
            shift_array[i] = in >> i;
        end
    end

    // Decode the control signal
    reg [2:0] shift_amount;
    always @(*) begin
        shift_amount = ctrl;
    end

    // Select the correct row from the shift array
    always @(*) begin
        out = shift_array[shift_amount];
    end
endmodule