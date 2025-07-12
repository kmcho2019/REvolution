module ROM #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8,
    parameter DEFAULT_VALUE = 16'h0000,
    parameter ENABLE_ADDR_CHECK = 1,
    parameter MEM_INIT [0:255] = '{default: 16'h0000}
) (
    input [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] dout,
    output logic addr_error
);

    // Memory array declaration with parameterized size
    logic [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

    // Initialize memory with parameter values
    initial begin
        foreach(mem[i]) begin
            mem[i] = MEM_INIT[i];
        end
    end

    // Address range checking (optional)
    generate if (ENABLE_ADDR_CHECK) begin
        always_comb addr_error = (addr >= 2**ADDR_WIDTH);
    end else begin
        assign addr_error = 1'b0;
    end endgenerate

    // Read operation with default value fallback
    always_comb begin
        if (ENABLE_ADDR_CHECK && addr_error) begin
            dout = DEFAULT_VALUE;
        end else begin
            dout = mem[addr];
        end
    end

endmodule