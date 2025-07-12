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
    
    // Shift register memory (circular buffer)
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [2:0] write_ptr;
    
    // Barrel shifter for read position calculation
    wire [2:0] read_offset;
    wire [2:0] read_pos;
    
    assign read_offset = DEPTH - 1 - read_addr;
    assign read_pos = write_ptr + read_offset;
    
    // Write operation with shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize memory and pointer
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
            write_ptr <= 3'b0;
        end
        else begin
            // Shift all memory positions
            for (integer i = DEPTH-1; i > 0; i = i - 1)
                mem[i] <= mem[i-1];
            
            // Handle write operation
            if (write_en) begin
                mem[0] <= write_data;
                write_ptr <= write_addr;
            end
            else begin
                mem[0] <= mem[DEPTH-1];
            end
        end
    end
    
    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            // Read from calculated position
            read_data <= mem[read_pos[2:0]];
        end
        else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule