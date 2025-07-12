module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [2:0] pointer;  // Pointer to track the current position in the buffer
reg [7:0] buffer;  // Circular buffer to hold the bits

always @(posedge clk) begin
    // Update the buffer with the new input bit
    buffer <= {buffer[6:0], d};
    
    // Update the pointer
    pointer <= pointer + 1;
    
    // Handle wrap-around for the pointer
    if (pointer == 8) begin
        pointer <= 0;
    end
end

// Assign the output q based on the current state of the buffer
always @(*) begin
    case (pointer)
        3'd0: q <= buffer;
        3'd1: q <= {buffer[6:0], buffer[7]};
        3'd2: q <= {buffer[5:0], buffer[7:6]};
        3'd3: q <= {buffer[4:0], buffer[7:5]};
        3'd4: q <= {buffer[3:0], buffer[7:4]};
        3'd5: q <= {buffer[2:0], buffer[7:3]};
        3'd6: q <= {buffer[1:0], buffer[7:2]};
        3'd7: q <= {buffer[0], buffer[7:1]};
    endcase
end

// Initialize the buffer and pointer
initial begin
    buffer = 8'd0;
    pointer = 3'd0;
end

endmodule