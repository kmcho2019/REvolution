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
    
    // Dual bank memory
    reg [WIDTH-1:0] bank_A [0:DEPTH-1];
    reg [WIDTH-1:0] bank_B [0:DEPTH-1];
    
    // Bank selection and shadow registers
    reg bank_sel;
    reg [WIDTH-1:0] shadow_reg;
    reg [2:0] prev_read_addr;
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            bank_A[i] = {WIDTH{1'b0}};
            bank_B[i] = {WIDTH{1'b0}};
        end
        bank_sel = 1'b0;
        shadow_reg = {WIDTH{1'b0}};
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                bank_A[i] <= {WIDTH{1'b0}};
                bank_B[i] <= {WIDTH{1'b0}};
            end
            bank_sel <= 1'b0;
            shadow_reg <= {WIDTH{1'b0}};
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Bank switching and write operation
            bank_sel <= ~bank_sel;
            
            if (write_en) begin
                if (bank_sel) begin
                    bank_A[write_addr] <= write_data;
                end else begin
                    bank_B[write_addr] <= write_data;
                end
            end
            
            // Pre-fetch and read operation
            if (read_en) begin
                // Current read from opposite bank
                read_data <= bank_sel ? bank_B[read_addr] : bank_A[read_addr];
                
                // Pre-fetch next likely address (simple +1 prediction)
                shadow_reg <= bank_sel ? bank_B[read_addr + 1] : bank_A[read_addr + 1];
            end else begin
                // Hold last value when not reading
                read_data <= read_data;
            end
        end
    end
    
    // Optional: Combinational output for immediate read
    // wire [WIDTH-1:0] immediate_read = read_en ? 
    //     (bank_sel ? bank_B[read_addr] : bank_A[read_addr]) : {WIDTH{1'b0}};

endmodule