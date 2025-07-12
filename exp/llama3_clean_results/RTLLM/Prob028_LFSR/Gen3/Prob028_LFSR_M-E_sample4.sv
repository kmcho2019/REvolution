module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] buffer;  // 4-bit circular buffer
reg [1:0] pointer;  // 2-bit pointer to keep track of the current position

always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        buffer <= 4'b0;
        pointer <= 2'b0;
    end else begin
        // Generate the feedback signal
        reg feedback = ~(buffer[3] ^ buffer[2]);
        
        // Update the buffer based on the pointer
        case (pointer)
            2'b00: buffer <= {buffer[2:0], feedback};
            2'b01: buffer <= {buffer[1:0], buffer[3], feedback};
            2'b10: buffer <= {buffer[0], buffer[3:1], feedback};
            2'b11: buffer <= {buffer, feedback};
        endcase
        
        // Update the pointer
        pointer <= pointer + 1;
        
        // If the pointer reaches the end, reset it to the beginning
        if (pointer == 2'b11) begin
            pointer <= 2'b0;
        end
    end
end

// Always output the current state of the buffer
assign out = buffer;

endmodule