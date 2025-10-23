module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define a memory type that stores both the digit and valid bit
typedef struct packed {
    logic [3:0] digit;
    logic valid;
} code_entry_t;

// Create the lookup table (ROM)
code_entry_t code_rom [256];

// Initialize the ROM
initial begin
    // Default all entries to invalid
    for (int i = 0; i < 256; i++) begin
        code_rom[i].digit = 4'b0;
        code_rom[i].valid = 1'b0;
    end
    
    // Set valid entries
    code_rom[8'h45] = '{digit: 0, valid: 1};
    code_rom[8'h16] = '{digit: 1, valid: 1};
    code_rom[8'h1e] = '{digit: 2, valid: 1};
    code_rom[8'h26] = '{digit: 3, valid: 1};
    code_rom[8'h25] = '{digit: 4, valid: 1};
    code_rom[8'h2e] = '{digit: 5, valid: 1};
    code_rom[8'h36] = '{digit: 6, valid: 1};
    code_rom[8'h3d] = '{digit: 7, valid: 1};
    code_rom[8'h3e] = '{digit: 8, valid: 1};
    code_rom[8'h46] = '{digit: 9, valid: 1};
end

// Continuous assignment for outputs
assign out = code_rom[code].digit;
assign valid = code_rom[code].valid;

endmodule