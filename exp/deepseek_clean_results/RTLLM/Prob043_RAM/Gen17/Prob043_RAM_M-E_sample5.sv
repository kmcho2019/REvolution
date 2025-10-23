module RAM (
    input clk,                  // Main clock
    input rst_n,                // Active-low reset
    input write_en,             // Write enable
    input [2:0] write_addr,     // Write address
    input [5:0] write_data,     // Write data
    input read_clk,             // Optional separate read clock
    input read_en,              // Read enable
    input [2:0] read_addr,      // Read address
    output reg [5:0] read_data, // Registered read data
    output reg read_valid       // Data valid flag
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    
    // Write port
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize memory
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // Write operation
            mem[write_addr] <= write_data;
        end
    end
    
    // Read port with pipeline registers
    reg [WIDTH-1:0] read_data_stage1;
    reg read_valid_stage1;
    
    always @(posedge read_clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data_stage1 <= {WIDTH{1'b0}};
            read_valid_stage1 <= 1'b0;
            read_data <= {WIDTH{1'b0}};
            read_valid <= 1'b0;
        end
        else begin
            // Stage 1: Memory access
            read_valid_stage1 <= read_en;
            if (write_en && (write_addr == read_addr)) begin
                // Write-through behavior
                read_data_stage1 <= write_data;
            end
            else begin
                read_data_stage1 <= mem[read_addr];
            end
            
            // Stage 2: Output register
            read_data <= read_data_stage1;
            read_valid <= read_valid_stage1;
        end
    end

endmodule