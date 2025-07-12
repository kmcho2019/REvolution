module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

// Process lower 2 bits (group 0)
wire [1:0] group0 = in[1:0];
wire [1:0] group0_mask = group0 & ~(group0 - 1);
reg [1:0] group0_pos;

// Process upper 2 bits (group 1)
wire [1:0] group1 = in[3:2];
wire [1:0] group1_mask = group1 & ~(group1 - 1);
reg [1:0] group1_pos;

// Encode positions for each group
always @(*) begin
    case (group0_mask)
        2'b01: group0_pos = 2'b00;
        2'b10: group0_pos = 2'b01;
        default: group0_pos = 2'b00;
    endcase
    
    case (group1_mask)
        2'b01: group1_pos = 2'b10;
        2'b10: group1_pos = 2'b11;
        default: group1_pos = 2'b00;
    endcase
end

// Final selection with priority to lower group
always @(*) begin
    if (|group0) begin
        pos = group0_pos;
    end
    else if (|group1) begin
        pos = group1_pos;
    end
    else begin
        pos = 2'b00;
    end
end

endmodule