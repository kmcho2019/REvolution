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
    parameter REGISTER_OUTPUT = 0; // 0 for combinational read, 1 for registered

    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Internal signals
    reg [WIDTH-1:0] read_data_int;

    // Write operation (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all memory locations to 0
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Combinational read operation
    always @(*) begin
        if (read_en) begin
            read_data_int = mem[read_addr];
        end
        // else keep previous value (more power efficient)
    end

    // Optional output register for better timing
    generate
        if (REGISTER_OUTPUT) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data <= {WIDTH{1'b0}};
                end
                else begin
                    read_data <= read_data_int;
                end
            end
        end
        else begin
            always @(*) begin
                read_data = read_data_int;
            end
        end
    endgenerate

endmodule