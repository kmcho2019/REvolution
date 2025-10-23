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
    parameter BYPASS = 1;  // 1 enables write-through behavior
    
    // Memory banks (split for independent access)
    reg [WIDTH-1:0] mem_bank0 [0:DEPTH/2-1];
    reg [WIDTH-1:0] mem_bank1 [0:DEPTH/2-1];
    
    // Shadow write buffer
    reg [WIDTH-1:0] shadow_data;
    reg [2:0] shadow_addr;
    reg shadow_valid;
    
    // Initialization
    integer i;
    initial begin
        for (i = 0; i < DEPTH/2; i = i + 1) begin
            mem_bank0[i] = {WIDTH{1'b0}};
            mem_bank1[i] = {WIDTH{1'b0}};
        end
        shadow_valid = 1'b0;
    end
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH/2; i = i + 1) begin
                mem_bank0[i] <= {WIDTH{1'b0}};
                mem_bank1[i] <= {WIDTH{1'b0}};
            end
            shadow_valid <= 1'b0;
        end else if (write_en) begin
            // Store in shadow buffer first
            shadow_data <= write_data;
            shadow_addr <= write_addr;
            shadow_valid <= 1'b1;
            
            // Actual memory write (banked)
            if (write_addr[2]) 
                mem_bank1[write_addr[1:0]] <= write_data;
            else
                mem_bank0[write_addr[1:0]] <= write_data;
        end else begin
            shadow_valid <= 1'b0;
        end
    end
    
    // Read operation with pipeline register
    reg [WIDTH-1:0] read_data_next;
    always @(*) begin
        if (read_en) begin
            // Check for write bypass
            if (BYPASS && shadow_valid && (read_addr == shadow_addr))
                read_data_next = shadow_data;
            else if (read_addr[2])
                read_data_next = mem_bank1[read_addr[1:0]];
            else
                read_data_next = mem_bank0[read_addr[1:0]];
        end else begin
            read_data_next = {WIDTH{1'b0}};
        end
    end
    
    // Output pipeline stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            read_data <= {WIDTH{1'b0}};
        else
            read_data <= read_data_next;
    end

endmodule