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
    parameter PIPELINED = 1;  // Enable pipelined reads
    
    // Split memory into even/odd banks
    reg [WIDTH-1:0] mem_even [0:(DEPTH/2)-1];
    reg [WIDTH-1:0] mem_odd [0:(DEPTH/2)-1];
    
    // Pipeline registers
    reg [WIDTH-1:0] read_data_pipe;
    reg [2:0] read_addr_pipe;
    reg read_en_pipe;
    
    // Write bypass registers
    reg [WIDTH-1:0] write_bypass_data;
    reg [2:0] write_bypass_addr;
    reg write_bypass_valid;
    
    // Initialize memories
    integer i;
    initial begin
        for (i = 0; i < DEPTH/2; i = i + 1) begin
            mem_even[i] = {WIDTH{1'b0}};
            mem_odd[i] = {WIDTH{1'b0}};
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_bypass_valid <= 1'b0;
        end
        else begin
            // Handle write bypass for RAW hazards
            write_bypass_valid <= write_en;
            write_bypass_addr <= write_addr;
            write_bypass_data <= write_data;
            
            // Actual memory write
            if (write_en) begin
                if (write_addr[0])  // Odd address
                    mem_odd[write_addr[2:1]] <= write_data;
                else                // Even address
                    mem_even[write_addr[2:1]] <= write_data;
            end
        end
    end
    
    // Read operation stage 1 (address decode)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_en_pipe <= 1'b0;
            read_addr_pipe <= 3'b0;
        end
        else begin
            read_en_pipe <= read_en;
            read_addr_pipe <= read_addr;
        end
    end
    
    // Read operation stage 2 (data select)
    always @(*) begin
        // Check for write bypass first (RAW hazard)
        if (write_bypass_valid && (read_addr_pipe == write_bypass_addr)) begin
            read_data_pipe = write_bypass_data;
        end
        else if (read_addr_pipe[0]) begin  // Odd address
            read_data_pipe = mem_odd[read_addr_pipe[2:1]];
        end
        else begin                        // Even address
            read_data_pipe = mem_even[read_addr_pipe[2:1]];
        end
    end
    
    // Output register (optional pipeline stage)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (PIPELINED) begin
            read_data <= read_en_pipe ? read_data_pipe : {WIDTH{1'b0}};
        end
        else begin
            // Combinational path when not pipelined
            if (read_en) begin
                if (write_bypass_valid && (read_addr == write_bypass_addr)) begin
                    read_data <= write_bypass_data;
                end
                else if (read_addr[0]) begin
                    read_data <= mem_odd[read_addr[2:1]];
                end
                else begin
                    read_data <= mem_even[read_addr[2:1]];
                end
            end
            else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule