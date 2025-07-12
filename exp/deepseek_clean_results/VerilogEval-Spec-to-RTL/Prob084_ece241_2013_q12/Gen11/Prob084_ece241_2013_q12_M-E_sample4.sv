module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;
    wire [2:0] addr = {A, B, C};
    wire write_enable;
    
    // Falling edge detector for write operations
    reg enable_prev;
    always @(posedge clk) enable_prev <= enable;
    assign write_enable = enable_prev & ~enable;
    
    // Hybrid shift register with direct write capability
    always @(posedge clk) begin
        if (enable) begin
            // Shift operation
            Q <= {Q[6:0], S};
        end else if (write_enable) begin
            // Direct write operation
            Q[addr] <= S;
        end
    end
    
    // Tri-state output selection
    assign Z = (addr == 3'b000) ? Q[0] : 1'bz;
    assign Z = (addr == 3'b001) ? Q[1] : 1'bz;
    assign Z = (addr == 3'b010) ? Q[2] : 1'bz;
    assign Z = (addr == 3'b011) ? Q[3] : 1'bz;
    assign Z = (addr == 3'b100) ? Q[4] : 1'bz;
    assign Z = (addr == 3'b101) ? Q[5] : 1'bz;
    assign Z = (addr == 3'b110) ? Q[6] : 1'bz;
    assign Z = (addr == 3'b111) ? Q[7] : 1'bz;
    
    // Default pull-down when no output is selected
    pullup(Z);
endmodule