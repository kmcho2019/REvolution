module RAM (
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

// Using a reg array to implement the RAM
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Using a single always block for both write and read operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic: Initialize all memory locations to 0
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
        read_data <= {WIDTH{1'b0}};
    end else if (write_en) begin
        // Write operation
        RAM[write_addr] <= write_data;
    end
    
    // Read operation
    if (read_en) begin
        read_data <= RAM[read_addr];
    end else begin
        read_data <= {WIDTH{1'b0}};
    end
end

endmodule