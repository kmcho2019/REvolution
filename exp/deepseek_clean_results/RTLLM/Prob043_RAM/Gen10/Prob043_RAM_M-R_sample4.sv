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
    
    // Memory array implementation
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation
    always @(*) begin
        if (read_en) begin
            case (read_addr)
                3'd0: read_data = mem[0];
                3'd1: read_data = mem[1];
                3'd2: read_data = mem[2];
                3'd3: read_data = mem[3];
                3'd4: read_data = mem[4];
                3'd5: read_data = mem[5];
                3'd6: read_data = mem[6];
                3'd7: read_data = mem[7];
                default: read_data = {WIDTH{1'b0}};
            endcase
        end
        else begin
            read_data = {WIDTH{1'b0}};
        end
    end

endmodule