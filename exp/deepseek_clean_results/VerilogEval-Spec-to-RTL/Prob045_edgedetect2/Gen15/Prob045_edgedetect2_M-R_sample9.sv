module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Previous input storage
    reg [7:0] prev_in;
    
    // Edge detection combinational logic
    wire [7:0] edge_detect = in ^ prev_in;
    
    // Sequential logic for output and state
    always @(posedge clk) begin
        anyedge <= edge_detect;
        prev_in <= in;
    end

endmodule