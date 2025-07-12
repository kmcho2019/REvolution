module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [1:0] offset;  // Tracks virtual rotation offset (0-3)
reg [3:0] storage; // Actual storage (circular buffer)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        storage <= 4'b0;
        offset <= 2'b0;
        q <= 4'b0;
    end
    else if (load) begin
        storage <= data;
        offset <= 2'b0;
        q <= data;
    end
    else if (ena) begin
        // Virtual right shift by updating offset and forcing MSB to 0
        offset <= offset + 1;
        // Reconstruct output with new offset and zero in MSB
        q <= {1'b0, 
              storage[(offset+0)%4], 
              storage[(offset+1)%4], 
              storage[(offset+2)%4]};
        // Update storage with zero in what will be the new MSB position
        storage[(offset+3)%4] <= 1'b0;
    end
    else begin
        // Maintain current output when no operation
        q <= {storage[(offset+0)%4],
              storage[(offset+1)%4],
              storage[(offset+2)%4],
              storage[(offset+3)%4]};
    end
end

endmodule