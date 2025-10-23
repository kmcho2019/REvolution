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
    
    // Dual memory banks
    reg [WIDTH-1:0] bank_A [DEPTH-1:0];
    reg [WIDTH-1:0] bank_B [DEPTH-1:0];
    reg bank_toggle;
    
    // Bank selection signals
    wire current_write_bank = bank_toggle;
    wire current_read_bank = ~bank_toggle;
    
    // Synchronous operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset both banks and toggle state
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                bank_A[i] <= {WIDTH{1'b0}};
                bank_B[i] <= {WIDTH{1'b0}};
            end
            bank_toggle <= 1'b0;
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation - current bank
            if (write_en) begin
                if (current_write_bank)
                    bank_B[write_addr] <= write_data;
                else
                    bank_A[write_addr] <= write_data;
            end
            
            // Read operation - opposite bank
            if (read_en) begin
                read_data <= current_read_bank ? bank_B[read_addr] : bank_A[read_addr];
            end
            else begin
                read_data <= {WIDTH{1'b0}};
            end
            
            // Toggle bank selection
            bank_toggle <= ~bank_toggle;
        end
    end

endmodule