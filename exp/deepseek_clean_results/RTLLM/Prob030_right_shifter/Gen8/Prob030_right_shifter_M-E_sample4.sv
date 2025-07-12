module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [7:0] buffer;
reg [2:0] ptr;  // Pointer to current MSB position

initial begin
    buffer = 8'b0;
    ptr = 3'b0;
    q = 8'b0;
end

always @(posedge clk) begin
    // Store new input at current pointer position
    buffer[ptr] <= d;
    
    // Update pointer (circular buffer)
    ptr <= (ptr == 3'd7) ? 3'd0 : ptr + 3'd1;
    
    // Generate output by selecting 8-bit window
    case (ptr)
        3'd0: q <= {buffer[0], buffer[7:1]};
        3'd1: q <= {buffer[1:0], buffer[7:2]};
        3'd2: q <= {buffer[2:0], buffer[7:3]};
        3'd3: q <= {buffer[3:0], buffer[7:4]};
        3'd4: q <= {buffer[4:0], buffer[7:5]};
        3'd5: q <= {buffer[5:0], buffer[7:6]};
        3'd6: q <= {buffer[6:0], buffer[7]};
        3'd7: q <= buffer;
    endcase
end

endmodule