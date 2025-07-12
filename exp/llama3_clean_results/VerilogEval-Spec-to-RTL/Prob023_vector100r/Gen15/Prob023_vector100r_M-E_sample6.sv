module TopModule #(
    parameter WIDTH = 100
) (
    input  clk,    // Clock signal
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out,
    input  reset    // Reset signal
);

    reg [WIDTH-1:0] ram;  // RAM module
    reg [6:0] addr;       // Address counter for RAM
    reg [6:0] read_addr;  // Address counter for reading from RAM
    reg write_en;         // Write enable signal
    reg read_en;          // Read enable signal

    // Sequential logic to control the write and read operations
    always @(posedge clk) begin
        if (reset) begin
            addr <= 0;
            read_addr <= 0;
            write_en <= 0;
            read_en <= 0;
        end else begin
            // Write operation
            if (addr < WIDTH) begin
                ram[WIDTH - 1 - addr] <= in[addr];
                addr <= addr + 1;
                write_en <= 1;
            end else begin
                write_en <= 0;
            end

            // Read operation
            if (read_addr < WIDTH) begin
                out[read_addr] <= ram[WIDTH - 1 - read_addr];
                read_addr <= read_addr + 1;
                read_en <= 1;
            end else begin
                read_en <= 0;
            end
        end
    end

endmodule