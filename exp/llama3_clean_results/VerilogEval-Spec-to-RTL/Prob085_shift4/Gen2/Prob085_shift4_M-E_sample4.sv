module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] csr; // Current State Register
reg [3:0] nsr; // Next State Register

always @(posedge clk or posedge areset) begin
    if (areset) begin
        csr <= 4'b0;
        nsr <= 4'b0;
    end else begin
        // Update CSR with NSR on every clock edge
        csr <= nsr;
        
        // Determine NSR based on control signals
        if (load) begin
            nsr <= data;
        end else if (ena) begin
            nsr <= {1'b0, csr[3:1]};
        end else begin
            nsr <= csr;
        end
    end
end

assign q = csr;

endmodule