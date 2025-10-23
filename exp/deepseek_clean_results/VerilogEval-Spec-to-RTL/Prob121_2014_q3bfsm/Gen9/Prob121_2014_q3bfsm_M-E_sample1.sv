module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    reg [2:0] state;
    wire [3:0] rom_out; // {next_state[2:0], z}

    // ROM implementation as a lookup table
    // Address format: {state[2:0], x}
    // Data format: {next_state[2:0], z}
    assign rom_out = 
        ({state, x} == 4'b0000) ? 4'b0000 : // S0, x=0 -> S0, z=0
        ({state, x} == 4'b0001) ? 4'b0010 : // S0, x=1 -> S1, z=0
        ({state, x} == 4'b0010) ? 4'b0010 : // S1, x=0 -> S1, z=0
        ({state, x} == 4'b0011) ? 4'b1000 : // S1, x=1 -> S4, z=0
        ({state, x} == 4'b0100) ? 4'b0100 : // S2, x=0 -> S2, z=0
        ({state, x} == 4'b0101) ? 4'b0010 : // S2, x=1 -> S1, z=0
        ({state, x} == 4'b0110) ? 4'b0011 : // S3, x=0 -> S1, z=1
        ({state, x} == 4'b0111) ? 4'b0101 : // S3, x=1 -> S2, z=1
        ({state, x} == 4'b1000) ? 4'b0111 : // S4, x=0 -> S3, z=1
        ({state, x} == 4'b1001) ? 4'b1001 : // S4, x=1 -> S4, z=1
        4'b0000; // Default case (shouldn't occur)

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 0;
        end
        else begin
            state <= rom_out[3:1];
            z <= rom_out[0];
        end
    end

endmodule