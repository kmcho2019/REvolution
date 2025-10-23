module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Counter to keep track of the current byte position
logic [1:0] byte_pos, next_byte_pos;

// Assign next_byte_pos based on the current byte position and the input byte stream
assign next_byte_pos = (reset)? 0 : 
                       (byte_pos == 0 && in[3])? 1 : 
                       (byte_pos == 1)? 2 : 
                       (byte_pos == 2)? 0 : byte_pos;

// Assign done signal based on the current byte position
assign done = (byte_pos == 2);

// Update byte_pos on the positive edge of the clock
always_ff @(posedge clk) begin
    if (reset) begin
        byte_pos <= 0;
    end else begin
        byte_pos <= next_byte_pos;
    end
end

endmodule