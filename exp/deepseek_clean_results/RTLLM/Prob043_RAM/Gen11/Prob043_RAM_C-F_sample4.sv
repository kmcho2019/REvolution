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
    
    // Packed memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write address decoder
    wire [DEPTH-1:0] write_select;
    assign write_select = write_en ? (1 << write_addr) : {DEPTH{1'b0}};
    
    // Synchronous write and reset
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else begin
            // Decoded write enables
            if (write_select[0]) mem[0] <= write_data;
            if (write_select[1]) mem[1] <= write_data;
            if (write_select[2]) mem[2] <= write_data;
            if (write_select[3]) mem[3] <= write_data;
            if (write_select[4]) mem[4] <= write_data;
            if (write_select[5]) mem[5] <= write_data;
            if (write_select[6]) mem[6] <= write_data;
            if (write_select[7]) mem[7] <= write_data;
        end
    end
    
    // Balanced read mux with output hold
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
            endcase
        end
        // else hold previous value (power optimization)
    end

endmodule