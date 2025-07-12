module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

wire [1:0] lower_pos;
wire [1:0] upper_pos;
wire lower_active;
wire upper_active;

// Lower 2-bit priority encoder (bits [1:0])
assign lower_active = |in[1:0];
assign lower_pos = in[0] ? 2'b00 : 
                  in[1] ? 2'b01 : 
                  2'b00;

// Upper 2-bit priority encoder (bits [3:2])
assign upper_active = |in[3:2];
assign upper_pos = in[2] ? 2'b10 : 
                  in[3] ? 2'b11 : 
                  2'b00;

// Final output selection
always @(*) begin
    if (lower_active) begin
        pos = lower_pos;  // Priority to lower bits
    end
    else if (upper_active) begin
        pos = upper_pos;  // Then upper bits
    end
    else begin
        pos = 2'b00;      // All zeros case
    end
end

endmodule