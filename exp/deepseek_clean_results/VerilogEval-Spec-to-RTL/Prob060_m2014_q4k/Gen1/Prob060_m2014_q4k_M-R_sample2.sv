module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Declare individual flip-flops
    reg ff0, ff1, ff2, ff3;
    
    // Declare internal wires for connections
    wire d0, d1, d2, d3;
    
    // Input connection
    assign d0 = in;
    
    // Intermediate connections
    assign d1 = ff0;
    assign d2 = ff1;
    assign d3 = ff2;
    
    // Output assignment
    assign out = ff3;
    
    // Flip-flop implementations
    always @(posedge clk) begin
        if (!resetn) begin
            ff0 <= 1'b0;
            ff1 <= 1'b0;
            ff2 <= 1'b0;
            ff3 <= 1'b0;
        end else begin
            ff0 <= d0;
            ff1 <= d1;
            ff2 <= d2;
            ff3 <= d3;
        end
    end

endmodule