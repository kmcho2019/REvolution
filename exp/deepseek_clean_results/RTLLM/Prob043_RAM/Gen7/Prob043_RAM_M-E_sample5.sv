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
    
    // Individual memory registers with local control
    reg [WIDTH-1:0] loc_0, loc_1, loc_2, loc_3, 
                    loc_4, loc_5, loc_6, loc_7;
    
    // Write address decoder
    wire [DEPTH-1:0] write_select;
    assign write_select = (write_en) ? (1 << write_addr) : {DEPTH{1'b0}};
    
    // Write operations (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            loc_0 <= 0; loc_1 <= 0; loc_2 <= 0; loc_3 <= 0;
            loc_4 <= 0; loc_5 <= 0; loc_6 <= 0; loc_7 <= 0;
        end
        else begin
            if (write_select[0]) loc_0 <= write_data;
            if (write_select[1]) loc_1 <= write_data;
            if (write_select[2]) loc_2 <= write_data;
            if (write_select[3]) loc_3 <= write_data;
            if (write_select[4]) loc_4 <= write_data;
            if (write_select[5]) loc_5 <= write_data;
            if (write_select[6]) loc_6 <= write_data;
            if (write_select[7]) loc_7 <= write_data;
        end
    end
    
    // Read multiplexer with enable
    assign read_data = read_en ? 
        (read_addr == 0) ? loc_0 :
        (read_addr == 1) ? loc_1 :
        (read_addr == 2) ? loc_2 :
        (read_addr == 3) ? loc_3 :
        (read_addr == 4) ? loc_4 :
        (read_addr == 5) ? loc_5 :
        (read_addr == 6) ? loc_6 :
        loc_7 : {WIDTH{1'b0}};

endmodule