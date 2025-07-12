module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,  // $clog2(DEPTH) = 3
    input [5:0] write_data,  // WIDTH = 6
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    localparam ADDR_WIDTH = 3;
    
    // Dual-bank memory declaration
    reg [WIDTH-1:0] bank_a [0:DEPTH-1];
    reg [WIDTH-1:0] bank_b [0:DEPTH-1];
    
    // Control signals
    reg bank_sel;  // 0=Bank A, 1=Bank B
    reg [WIDTH-1:0] read_data_next;
    
    // Synchronous reset and initialization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < DEPTH; i++) begin
                bank_a[i] <= '0;
                bank_b[i] <= '0;
            end
            bank_sel <= 0;
            read_data <= '0;
        end else begin
            // Bank-switched write operation
            if (write_en) begin
                if (!bank_sel)
                    bank_a[write_addr] <= write_data;
                else
                    bank_b[write_addr] <= write_data;
                bank_sel <= ~bank_sel;  // Toggle bank selection
            end
            
            // Pipelined read operation
            read_data <= read_data_next;
        end
    end
    
    // Combinational read path with collision handling
    always_comb begin
        if (!read_en) begin
            read_data_next = '0;
        end else begin
            // Check for read-during-write collision
            if (write_en && (read_addr == write_addr)) begin
                // Return data from inactive bank (previous value)
                read_data_next = bank_sel ? bank_a[read_addr] : bank_b[read_addr];
            end else begin
                // Normal read from both banks (data is identical)
                read_data_next = bank_a[read_addr];
            end
        end
    end

endmodule