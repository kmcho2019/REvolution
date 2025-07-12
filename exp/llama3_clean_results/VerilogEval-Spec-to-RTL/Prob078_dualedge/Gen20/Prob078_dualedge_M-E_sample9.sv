module TopModule(
    input clk,  
    input d,    
    output reg q 
);

// Internal signal for clock-edge detection
reg clk_edge;

// Clock-edge detection
always @(posedge clk or negedge clk) begin
    clk_edge <= 1'b1;
end

always @(*)
    if (~clk_edge) begin
        clk_edge <= 1'b0;
    end

// Dual-edge triggered flip-flop using a multiplexer
always @(posedge clk_edge) begin
    if (clk == 1'b1) begin
        q <= d;
    end else begin
        q <= d;
    end
    clk_edge <= 1'b0;
end

endmodule