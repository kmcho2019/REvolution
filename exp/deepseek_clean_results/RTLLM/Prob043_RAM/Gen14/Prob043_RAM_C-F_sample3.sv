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
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write address decoder
    wire [DEPTH-1:0] write_select;
    assign write_select = (write_en) ? (1 << write_addr) : {DEPTH{1'b0}};

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                if (write_select[i]) 
                    mem[i] <= write_data;
            end
        end
    end

    // Read operation - registered output for better timing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            read_data <= mem[read_addr];
        end
        // else hold previous value (power optimization)
    end

endmodule