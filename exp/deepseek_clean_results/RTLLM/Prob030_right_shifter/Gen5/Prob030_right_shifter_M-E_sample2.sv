module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [2:0] ptr = 3'b0;  // Pointer to current MSB position
reg [7:0] buffer = 8'b0;

always @(posedge clk) begin
    // Store new data at current pointer position
    buffer[ptr] <= d;
    
    // Update pointer (decrement with wrap-around)
    ptr <= (ptr == 3'b0) ? 3'b111 : (ptr - 1);
    
    // Generate output by rotating based on pointer
    case(ptr)
        3'd0: q <= buffer;
        3'd1: q <= {buffer[0], buffer[7:1]};
        3'd2: q <= {buffer[1:0], buffer[7:2]};
        3'd3: q <= {buffer[2:0], buffer[7:3]};
        3'd4: q <= {buffer[3:0], buffer[7:4]};
        3'd5: q <= {buffer[4:0], buffer[7:5]};
        3'd6: q <= {buffer[5:0], buffer[7:6]};
        3'd7: q <= {buffer[6:0], buffer[7]};
    endcase
end

endmodule