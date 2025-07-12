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
    parameter DEPTH = 4;  // Per bank
    
    // Dual bank memory
    reg [WIDTH-1:0] bank_A [0:DEPTH-1];
    reg [WIDTH-1:0] bank_B [0:DEPTH-1];
    
    // Write pointer and bank selector
    reg write_bank_sel;
    reg [1:0] write_ptr_A, write_ptr_B;
    
    // Registered outputs
    reg [5:0] read_data_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset both banks
            for (int i = 0; i < DEPTH; i++) begin
                bank_A[i] <= {WIDTH{1'b0}};
                bank_B[i] <= {WIDTH{1'b0}};
            end
            write_ptr_A <= 0;
            write_ptr_B <= 0;
            write_bank_sel <= 0;
            read_data <= 0;
        end
        else begin
            // Write operation - alternates between banks
            if (write_en) begin
                if (write_bank_sel) begin
                    bank_B[write_addr[1:0]] <= write_data;
                    write_ptr_B <= write_ptr_B + 1;
                end
                else begin
                    bank_A[write_addr[1:0]] <= write_data;
                    write_ptr_A <= write_ptr_A + 1;
                end
                write_bank_sel <= ~write_bank_sel;
            end
            
            // Read operation - can access either bank
            if (read_en) begin
                read_data <= read_addr[2] ? bank_B[read_addr[1:0]] : 
                                            bank_A[read_addr[1:0]];
            end
            else begin
                read_data <= read_data; // Hold last value
            end
        end
    end

endmodule