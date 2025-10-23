module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data,
    output reg collision
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    parameter PIPELINED = 1;  // Enable pipelined reads
    
    // Memory array with parity bit
    reg [WIDTH:0] mem [0:DEPTH-1];  // [6:0] - [5:0] data + 1 parity
    
    // Shadow registers for write operation
    reg [2:0] write_addr_reg;
    reg [5:0] write_data_reg;
    reg write_pending;
    
    // Gray coded addresses for power optimization
    reg [2:0] prev_read_addr;
    wire [2:0] gray_read_addr = read_addr ^ (read_addr >> 1);
    
    // Initialize memory with parity
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {1'b0, {WIDTH{1'b0}}};  // Initialize with parity=0
        end
    end
    
    // Write operation pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pending <= 1'b0;
            write_addr_reg <= 3'b0;
            write_data_reg <= {WIDTH{1'b0}};
        end
        else begin
            // Stage 1: Capture write request
            if (write_en) begin
                write_addr_reg <= write_addr;
                write_data_reg <= write_data;
                write_pending <= 1'b1;
            end
            
            // Stage 2: Perform actual write with parity
            if (write_pending) begin
                mem[write_addr_reg] <= {^write_data_reg, write_data_reg};
                write_pending <= 1'b0;
            end
        end
    end
    
    // Collision detection
    always @(posedge clk) begin
        collision <= write_pending && (write_addr_reg == read_addr);
    end
    
    // Read operation pipeline
    generate
        if (PIPELINED) begin
            // Pipelined version with output register
            reg [5:0] read_data_pipe;
            reg read_valid;
            
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data_pipe <= {WIDTH{1'b0}};
                    read_valid <= 1'b0;
                    prev_read_addr <= 3'b0;
                end
                else begin
                    // Stage 1: Address decode
                    prev_read_addr <= gray_read_addr;
                    if (read_en) begin
                        read_data_pipe <= mem[read_addr][WIDTH-1:0];
                    end
                    read_valid <= read_en;
                    
                    // Stage 2: Output register
                    if (read_valid) begin
                        read_data <= read_data_pipe;
                    end
                end
            end
        end
        else begin
            // Combinational read path
            always @(*) begin
                if (read_en) begin
                    read_data = mem[read_addr][WIDTH-1:0];
                end
                else begin
                    read_data = {WIDTH{1'b0}};
                end
            end
        end
    endgenerate

endmodule