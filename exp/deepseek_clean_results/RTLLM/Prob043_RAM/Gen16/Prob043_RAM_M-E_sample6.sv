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
    
    // Banked memory arrays (even and odd)
    reg [WIDTH-1:0] mem_even [0:(DEPTH/2)-1];
    reg [WIDTH-1:0] mem_odd [0:(DEPTH/2)-1];
    
    // Internal signals
    wire [2:0] write_bank_addr = write_addr[2:1];
    wire [2:0] read_bank_addr = read_addr[2:1];
    wire write_to_even = ~write_addr[0];
    wire write_to_odd = write_addr[0];
    wire read_from_even = ~read_addr[0];
    wire read_from_odd = read_addr[0];
    
    // Conflict detection
    wire read_write_conflict = (write_en && read_en && (write_addr == read_addr));
    wire [5:0] conflict_bypass_data = write_data;
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < DEPTH/2; i = i + 1) begin
            mem_even[i] = {WIDTH{1'b0}};
            mem_odd[i] = {WIDTH{1'b0}};
        end
    end
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (~rst_n) begin
            for (i = 0; i < DEPTH/2; i = i + 1) begin
                mem_even[i] <= {WIDTH{1'b0}};
                mem_odd[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            if (write_to_even)
                mem_even[write_bank_addr] <= write_data;
            if (write_to_odd)
                mem_odd[write_bank_addr] <= write_data;
        end
    end
    
    // Pipelined read operation with bypass
    always @(posedge clk) begin
        if (~rst_n)
            read_data <= {WIDTH{1'b0}};
        else if (read_en) begin
            if (read_write_conflict)
                read_data <= conflict_bypass_data;
            else if (read_from_even)
                read_data <= mem_even[read_bank_addr];
            else if (read_from_odd)
                read_data <= mem_odd[read_bank_addr];
        end
        else
            read_data <= {WIDTH{1'b0}};
    end

endmodule