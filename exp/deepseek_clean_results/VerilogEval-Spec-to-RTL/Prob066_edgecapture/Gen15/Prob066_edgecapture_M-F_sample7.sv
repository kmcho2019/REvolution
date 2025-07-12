module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Two-stage pipeline for proper edge detection
    reg [31:0] prev_in;  // cycle N-1
    reg [31:0] curr_in;  // cycle N
    
    // Output memory register
    reg [31:0] out_reg;
    
    // Falling edge detection
    wire [31:0] falling_edge;
    
    assign falling_edge = prev_in & ~curr_in;
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            curr_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Shift input through pipeline
            prev_in <= curr_in;
            curr_in <= in;
            
            // Capture and hold falling edges
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule