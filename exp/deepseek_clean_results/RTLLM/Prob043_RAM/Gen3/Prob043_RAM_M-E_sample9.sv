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
    
    // Memory array with registered output
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] mem_out;
    reg [2:0] init_counter = 0;
    
    // Combined read/write operation with write-through
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Staggered memory initialization to reduce power spike
            if (init_counter < DEPTH) begin
                mem[init_counter] = {WIDTH{1'b0}};
                init_counter = init_counter + 1;
            end
            mem_out <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation has priority
            if (write_en) begin
                mem[write_addr] = write_data;
            end
            
            // Read operation with write-through handling
            if (read_en) begin
                // If reading same address being written, use new data
                if (write_en && (write_addr == read_addr)) begin
                    mem_out <= write_data;
                end
                else begin
                    mem_out <= mem[read_addr];
                end
            end
        end
    end
    
    // Output with enable
    assign read_data = read_en ? mem_out : {WIDTH{1'b0}};

endmodule