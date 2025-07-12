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
    
    // Packed array implementation
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    // Write operations (synchronous)
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            memory[write_addr] <= write_data;
        end
    end
    
    // Read operations (combinational)
    always @(*) begin
        if (read_en) begin
            case (read_addr)
                3'd0: read_data = memory[0];
                3'd1: read_data = memory[1];
                3'd2: read_data = memory[2];
                3'd3: read_data = memory[3];
                3'd4: read_data = memory[4];
                3'd5: read_data = memory[5];
                3'd6: read_data = memory[6];
                3'd7: read_data = memory[7];
                default: read_data = {WIDTH{1'b0}};
            endcase
        end
        else begin
            read_data = {WIDTH{1'b0}};
        end
    end

endmodule