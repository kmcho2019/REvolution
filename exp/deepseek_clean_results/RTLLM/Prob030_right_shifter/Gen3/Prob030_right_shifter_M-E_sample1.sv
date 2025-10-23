module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [2:0] write_ptr;  // Pointer to current MSB position (0-7)
reg [7:0] data_reg;   // Circular buffer storage

always @(posedge clk) begin
    // Store new data at current pointer position
    data_reg[write_ptr] <= d;
    
    // Update pointer with wrap-around
    write_ptr <= (write_ptr == 3'b0) ? 3'b111 : (write_ptr - 1);
    
    // Generate parallel output by rotating based on pointer
    case(write_ptr)
        3'd0: q <= data_reg;
        3'd1: q <= {data_reg[0], data_reg[7:1]};
        3'd2: q <= {data_reg[1:0], data_reg[7:2]};
        3'd3: q <= {data_reg[2:0], data_reg[7:3]};
        3'd4: q <= {data_reg[3:0], data_reg[7:4]};
        3'd5: q <= {data_reg[4:0], data_reg[7:5]};
        3'd6: q <= {data_reg[5:0], data_reg[7:6]};
        3'd7: q <= {data_reg[6:0], data_reg[7]};
    endcase
end

// Initialize pointer and registers
initial begin
    write_ptr = 3'b111;  // Start pointing to MSB
    data_reg = 8'b0;
    q = 8'b0;
end

endmodule