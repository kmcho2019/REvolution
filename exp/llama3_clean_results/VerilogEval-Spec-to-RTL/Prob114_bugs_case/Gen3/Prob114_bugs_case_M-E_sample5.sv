module TopModule (
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

// Define the lookup table
localparam scancode_table_size = 10;
reg [7:0] scancode_table [scancode_table_size - 1:0] = {
    8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
};
reg [3:0] output_table [scancode_table_size - 1:0] = {
    4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9
};

always @(*) begin
    out = 4'd0;
    valid = 1'b0;
    
    for (int i = 0; i < scancode_table_size; i++) begin
        if (code == scancode_table[i]) begin
            out = output_table[i];
            valid = 1'b1;
            break;
        end
    end
end

endmodule