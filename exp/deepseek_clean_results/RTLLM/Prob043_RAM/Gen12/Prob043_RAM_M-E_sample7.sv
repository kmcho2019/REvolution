module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory banks
    reg [WIDTH-1:0] bank_A [0:DEPTH-1];
    reg [WIDTH-1:0] bank_B [0:DEPTH-1];
    
    // Bank selector flip-flop
    reg write_bank_select;
    
    // Reset and bank switching logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_bank_select <= 0;
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                bank_A[i] <= 0;
                bank_B[i] <= 0;
            end
        end
        else if (write_en) begin
            write_bank_select <= ~write_bank_select;
        end
    end
    
    // Write operations
    always @(posedge clk) begin
        if (write_en) begin
            if (write_bank_select) begin
                bank_B[write_addr] <= write_data;
            end
            else begin
                bank_A[write_addr] <= write_data;
            end
        end
    end
    
    // Read operations (combinational)
    assign read_data = read_en ? 
        (write_bank_select ? bank_A[read_addr] : bank_B[read_addr]) : 
        {WIDTH{1'b0}};

endmodule