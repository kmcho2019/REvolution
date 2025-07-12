module ROM #(
    parameter INIT_FILE = "",  // Optional initialization file
    parameter REGISTER_OUTPUT = 0  // Set to 1 for registered output
) (
    input wire clk,           // Optional clock for registered output
    input wire en,            // Enable signal
    input wire [7:0] addr,
    output reg [15:0] dout    // Changed to reg for registered output option
);

    // Packed memory array declaration (more synthesis-friendly)
    (* rom_style = "block" *) reg [15:0] mem [0:255];

    // Initialize memory
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end else begin
            // Initialize only used locations
            mem[0] = 16'hA0A0;
            mem[1] = 16'hB1B1;
            mem[2] = 16'hC2C2;
            mem[3] = 16'hD3D3;
            // Other locations will be optimized away by synthesis
        end
    end

    // Internal combinational output
    wire [15:0] dout_comb = en ? mem[addr] : 16'bz;

    generate
        if (REGISTER_OUTPUT) begin
            // Registered output version
            always @(posedge clk) begin
                dout <= dout_comb;
            end
        end else begin
            // Combinational output version
            always @(*) begin
                dout = dout_comb;
            end
        end
    endgenerate

endmodule