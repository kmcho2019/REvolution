module TopModule(
    input  [3:0] in,
    output logic [1:0] pos // Declare pos as logic for clarity and compatibility
);

always_comb begin
    pos = 2'b00; // Initialize pos to 0
    if (in[3]) begin // Check MSB first
        pos = 2'b11; // Position 3
    end else if (in[2]) begin
        pos = 2'b10; // Position 2
    end else if (in[1]) begin
        pos = 2'b01; // Position 1
    end else if (in[0]) begin
        // No need to reassign pos = 2'b00 here, as it's already initialized to 2'b00
    end
end

endmodule