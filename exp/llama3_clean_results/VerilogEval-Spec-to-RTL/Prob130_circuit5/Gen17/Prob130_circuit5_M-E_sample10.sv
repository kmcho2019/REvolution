module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    reg [3:0] rom_out;

    // Initialize the ROM contents based on the simulation waveforms
    always @(*) begin
        case (c)
            4'd0: rom_out = b;
            4'd1: rom_out = e;
            4'd2: rom_out = a;
            4'd3: rom_out = d;
            default: rom_out = 4'd15;
        endcase
    end

    // Use the ROM output as the final output
    always @(*) begin
        q = rom_out;
    end

    // Alternative implementation using a ROM-like structure
    // reg [3:0] rom_data [15:0];
    // initial begin
    //     rom_data[0] = b;
    //     rom_data[1] = e;
    //     rom_data[2] = a;
    //     rom_data[3] = d;
    //     for (int i = 4; i < 16; i++) begin
    //         rom_data[i] = 4'd15;
    //     end
    // end
    // always @(*) begin
    //     q = rom_data[c];
    // end

endmodule