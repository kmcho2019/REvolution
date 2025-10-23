module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                  clk,
    input                  rst_n,
    input                  write_en,
    input      [2:0]       write_addr,   // 3 bits for addressing 8 locations
    input      [WIDTH-1:0] write_data,
    input                  read_en,
    input      [2:0]       read_addr,    // 3 bits for addressing 8 locations
    output reg [WIDTH-1:0] read_data
);

// RAM array: DEPTH locations of WIDTH bits each, initialized to 0
reg [WIDTH-1:0] RAM [0:DEPTH-1];

// Write operation: synchronous, active on posedge clk or negedge rst_n
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all RAM locations to 0
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Read operation: synchronous, active on posedge clk or negedge rst_n
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= {WIDTH{1'b0}};
    end else if (read_en) begin
        read_data <= RAM[read_addr];
    end else begin
        read_data <= {WIDTH{1'b0}};
    end
end

endmodule