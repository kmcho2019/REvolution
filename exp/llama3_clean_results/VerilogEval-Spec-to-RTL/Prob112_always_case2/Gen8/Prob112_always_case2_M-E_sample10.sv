module TopModule(
    input  [3:0] in,
    output logic [1:0] pos
);

always_comb begin
    logic [1:0] temp_pos;
    temp_pos = 2'b00; // Initialize temp_pos to 0

    // Check MSB first
    if (in[3]) begin
        temp_pos = 2'b11; // Position 3
    end else if (in[2]) begin
        temp_pos = 2'b10; // Position 2
    end else if (in[1]) begin
        temp_pos = 2'b01; // Position 1
    end 

    pos = temp_pos;
end

endmodule