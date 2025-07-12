module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] data;
    wire [2:0] rot_amt = {A, B, C};
    wire [7:0] rotated_data;
    
    // Barrel shifter/rotator
    assign rotated_data = enable ? {data[6:0], S} : 
                        (data << rot_amt) | (data >> (8 - rot_amt));
    
    // Fixed output tap (position 0 after rotation)
    assign Z = data[0];
    
    always @(posedge clk) begin
        if (enable) begin
            // Standard shift operation
            data <= {data[6:0], S};
        end else begin
            // Rotate operation for read access
            data <= rotated_data;
        end
    end
endmodule