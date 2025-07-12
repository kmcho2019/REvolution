module HybridRAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

// Register file
reg [5:0] reg_file [7:0];

// SRAM array
reg [5:0] sram_array [7:0];

// Cache-like mechanism
reg [2:0] cache_tag [7:0];
reg [5:0] cache_data [7:0];

// Write logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic
        for (int i = 0; i < DEPTH; i++) begin
            reg_file[i] <= 6'b0;
            sram_array[i] <= 6'b0;
            cache_tag[i] <= 3'b0;
            cache_data[i] <= 6'b0;
        end
    end else if (write_en) begin
        // Write to register file or SRAM array
        if (cache_tag[write_addr] == 1'b1) begin
            // Write to register file
            reg_file[write_addr] <= write_data;
        end else begin
            // Write to SRAM array
            sram_array[write_addr] <= write_data;
            // Update cache tag and data
            cache_tag[write_addr] <= 1'b1;
            cache_data[write_addr] <= write_data;
        end
    end
end

// Read logic
always @(posedge clk) begin
    if (read_en) begin
        // Read from register file or SRAM array
        if (cache_tag[read_addr] == 1'b1) begin
            // Read from register file
            read_data <= reg_file[read_addr];
        end else begin
            // Read from SRAM array
            read_data <= sram_array[read_addr];
        end
    end else begin
        // Clear read data
        read_data <= 6'b0;
    end
end

endmodule