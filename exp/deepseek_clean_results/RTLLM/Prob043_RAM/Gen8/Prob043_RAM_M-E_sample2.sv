module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array with shadow write buffer
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] shadow_mem;
    reg [2:0] shadow_addr;
    reg shadow_valid;
    
    // Pipeline registers
    reg [WIDTH-1:0] read_data_pipe;
    reg read_valid_pipe;
    reg [2:0] read_addr_pipe;
    
    // Clock gating signals
    wire read_clk_en = read_en | ~rst_n;
    wire write_clk_en = write_en | ~rst_n;
    
    // Gated clocks
    wire read_clk = clk & read_clk_en;
    wire write_clk = clk & write_clk_en;
    
    // Write path pipeline
    always @(posedge write_clk or negedge rst_n) begin
        if (!rst_n) begin
            shadow_valid <= 1'b0;
            // Initialize memory in stages to reduce reset current
            for (integer i = 0; i < DEPTH; i = i + 2) begin
                mem[i] <= {WIDTH{1'b0}};
                if (i+1 < DEPTH) mem[i+1] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // Stage 1: Capture write data in shadow register
            shadow_mem <= write_data;
            shadow_addr <= write_addr;
            shadow_valid <= 1'b1;
            
            // Stage 2: Commit to memory
            if (shadow_valid) begin
                mem[shadow_addr] <= shadow_mem;
            end
        end
    end
    
    // Read path pipeline
    always @(posedge read_clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data_pipe <= {WIDTH{1'b0}};
            read_valid_pipe <= 1'b0;
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Stage 1: Memory access
            if (read_en) begin
                read_addr_pipe <= read_addr;
                read_data_pipe <= mem[read_addr];
                read_valid_pipe <= 1'b1;
            end
            
            // Stage 2: Output registration
            if (read_valid_pipe) begin
                read_data <= mem[read_addr_pipe];
            end
            else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule