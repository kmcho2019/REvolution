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
    parameter BANK_SIZE = 4;

    // Memory banks
    reg [WIDTH-1:0] bank0 [0:BANK_SIZE-1];
    reg [WIDTH-1:0] bank1 [0:BANK_SIZE-1];
    
    // Shadow registers for fast read
    reg [WIDTH-1:0] shadow0 [0:BANK_SIZE-1];
    reg [WIDTH-1:0] shadow1 [0:BANK_SIZE-1];
    
    // Pipeline registers
    reg [WIDTH-1:0] read_data_reg;
    reg read_valid;
    
    // Bank selection logic
    wire write_bank_sel = write_addr[2];
    wire read_bank_sel = read_addr[2];
    wire [1:0] write_bank_addr = write_addr[1:0];
    wire [1:0] read_bank_addr = read_addr[1:0];
    
    // Write operation with bank balancing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize both banks
            for (int i = 0; i < BANK_SIZE; i = i + 1) begin
                bank0[i] <= {WIDTH{1'b0}};
                bank1[i] <= {WIDTH{1'b0}};
                shadow0[i] <= {WIDTH{1'b0}};
                shadow1[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // Write to appropriate bank and update shadow
            if (write_bank_sel) begin
                bank1[write_bank_addr] <= write_data;
                shadow1[write_bank_addr] <= write_data;
            end
            else begin
                bank0[write_bank_addr] <= write_data;
                shadow0[write_bank_addr] <= write_data;
            end
        end
        
        // Pre-fetch mechanism
        if (read_en) begin
            if (!read_bank_sel) begin
                shadow1[read_bank_addr] <= bank1[read_bank_addr];
            end
            else begin
                shadow0[read_bank_addr] <= bank0[read_bank_addr];
            end
        end
    end
    
    // Pipelined read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data_reg <= {WIDTH{1'b0}};
            read_valid <= 1'b0;
        end
        else begin
            read_valid <= read_en;
            if (read_en) begin
                read_data_reg <= read_bank_sel ? shadow1[read_bank_addr] 
                                             : shadow0[read_bank_addr];
            end
        end
    end
    
    // Output stage
    always @(*) begin
        read_data = read_valid ? read_data_reg : {WIDTH{1'b0}};
    end

endmodule