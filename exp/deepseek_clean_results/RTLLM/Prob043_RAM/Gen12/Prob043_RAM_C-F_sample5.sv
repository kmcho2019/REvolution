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
    parameter REGISTER_OUTPUT = 0; // 0: combinational, 1: registered
    
    // Memory as packed array for better area efficiency
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Internal read data before output control
    wire [WIDTH-1:0] raw_read_data = mem[read_addr];
    
    // Write operation with proper clock enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            // Handle potential write-through case
            mem[write_addr] <= write_data;
        end
    end
    
    // Output control
    generate
        if (REGISTER_OUTPUT) begin
            // Registered output for better timing
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data <= {WIDTH{1'b0}};
                end else begin
                    read_data <= read_en ? raw_read_data : {WIDTH{1'bz}};
                end
            end
        end else begin
            // Combinational output with high-Z when disabled
            always @(*) begin
                read_data = read_en ? raw_read_data : {WIDTH{1'bz}};
            end
        end
    endgenerate

endmodule