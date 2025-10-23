module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter CHUNK_SIZE = 64;  // Break into 8 chunks of 64 bits each

// Boundary conditions
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

// Next state computation
wire [WIDTH-1:0] next_q;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        // Boundary-aware neighbor selection
        wire left = (i == 0) ? left_boundary : q[i-1];
        wire right = (i == WIDTH-1) ? right_boundary : q[i+1];
        
        // Core Rule 90 logic - implemented in chunks
        if (i % CHUNK_SIZE == 0) begin
            // Insert pipeline register every CHUNK_SIZE bits if needed
            assign next_q[i] = left ^ right;
        end else begin
            assign next_q[i] = left ^ right;
        end
    end
endgenerate

// Clock gating logic for power optimization
wire clk_en = load || (|q || |next_q);  // Only clock when active

// State update with load functionality
always @(posedge clk) begin
    if (clk_en) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end
end

endmodule