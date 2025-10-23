// TopModule
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Update next state based on alive neighbors
genvar i;
generate
    for (i = 0; i < 256; i = i + 1) begin
        wire [3:0] alive_neighbors;
        assign alive_neighbors = 
            (q[(i-16+256)%256]? 1 : 0) + (q[(i-15+256)%256]? 1 : 0) + (q[(i-1+256)%256]? 1 : 0) +
            (q[(i+1)%256]? 1 : 0) + (q[(i+15)%256]? 1 : 0) + (q[(i+16)%256]? 1 : 0) +
            (q[(i+17)%256]? 1 : 0);
        
        assign next_q[i] = (alive_neighbors == 3) || (q[i] && (alive_neighbors == 2));
    end
endgenerate

// Update q on clock edge
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule