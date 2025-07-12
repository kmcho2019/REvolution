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
    
    // Individual registers for each memory location
    reg [WIDTH-1:0] mem_0, mem_1, mem_2, mem_3,
                    mem_4, mem_5, mem_6, mem_7;
    
    // Write address decoding
    wire [DEPTH-1:0] write_select;
    assign write_select = write_en ? (1 << write_addr) : {DEPTH{1'b0}};
    
    // Register update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_0 <= 0; mem_1 <= 0; mem_2 <= 0; mem_3 <= 0;
            mem_4 <= 0; mem_5 <= 0; mem_6 <= 0; mem_7 <= 0;
        end
        else begin
            if (write_select[0]) mem_0 <= write_data;
            if (write_select[1]) mem_1 <= write_data;
            if (write_select[2]) mem_2 <= write_data;
            if (write_select[3]) mem_3 <= write_data;
            if (write_select[4]) mem_4 <= write_data;
            if (write_select[5]) mem_5 <= write_data;
            if (write_select[6]) mem_6 <= write_data;
            if (write_select[7]) mem_7 <= write_data;
        end
    end
    
    // Multiplexer-based read with enable gate
    always @(*) begin
        if (!read_en) begin
            read_data = {WIDTH{1'b0}};
        end
        else case (read_addr)
            3'd0: read_data = mem_0;
            3'd1: read_data = mem_1;
            3'd2: read_data = mem_2;
            3'd3: read_data = mem_3;
            3'd4: read_data = mem_4;
            3'd5: read_data = mem_5;
            3'd6: read_data = mem_6;
            3'd7: read_data = mem_7;
            default: read_data = {WIDTH{1'b0}};
        endcase
    end

endmodule