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
    parameter DEPTH = 4;  // Each bank is half depth
    
    // Memory banks
    reg [WIDTH-1:0] bank_A [0:DEPTH-1];
    reg [WIDTH-1:0] bank_B [0:DEPTH-1];
    
    // Control signals
    reg write_bank;  // 0: Bank A, 1: Bank B
    reg [5:0] read_data_A, read_data_B;
    
    // Write operation with bank switching
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize both banks
            for (int i = 0; i < DEPTH; i = i + 1) begin
                bank_A[i] <= {WIDTH{1'b0}};
                bank_B[i] <= {WIDTH{1'b0}};
            end
            write_bank <= 1'b0;
        end
        else if (write_en) begin
            if (!write_bank) begin
                bank_A[write_addr[1:0]] <= write_data;  // Use lower 2 bits for bank addressing
            end
            else begin
                bank_B[write_addr[1:0]] <= write_data;
            end
            write_bank <= ~write_bank;  // Toggle bank for next write
        end
    end
    
    // Parallel speculative read from both banks
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data_A <= {WIDTH{1'b0}};
            read_data_B <= {WIDTH{1'b0}};
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            // Read from both banks in parallel
            read_data_A <= bank_A[read_addr[1:0]];
            read_data_B <= bank_B[read_addr[1:0]];
            
            // Priority to most recently written bank
            read_data <= (write_bank) ? read_data_B : read_data_A;
        end
        else begin
            read_data <= {WIDTH{1'b0}};
        end
    end
    
endmodule