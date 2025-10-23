module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

wire lower_valid = |in[3:0];
wire [1:0] lower_pos;
wire [1:0] upper_pos;

// Encode lower 4 bits
always @(*) begin
    casez(in[3:0])
        4'b0001: lower_pos = 2'd0;
        4'b001?: lower_pos = 2'd1;
        4'b01??: lower_pos = 2'd2;
        4'b1???: lower_pos = 2'd3;
        default: lower_pos = 2'd0;
    endcase
end

// Encode upper 4 bits
always @(*) begin
    casez(in[7:4])
        4'b0001: upper_pos = 2'd0;
        4'b001?: upper_pos = 2'd1;
        4'b01??: upper_pos = 2'd2;
        4'b1???: upper_pos = 2'd3;
        default: upper_pos = 2'd0;
    endcase
end

// Final position selection
always @(*) begin
    if (lower_valid)
        pos = {1'b0, lower_pos};
    else if (|in[7:4])
        pos = {1'b1, upper_pos};
    else
        pos = 3'd0;
end

endmodule