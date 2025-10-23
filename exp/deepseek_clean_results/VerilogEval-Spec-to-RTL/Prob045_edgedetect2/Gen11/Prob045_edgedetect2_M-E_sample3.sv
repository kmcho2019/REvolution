module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Shared delay element (1 cycle delay)
    reg [7:0] delayed_in;
    
    // Edge detection logic
    always @(posedge clk) begin
        delayed_in <= in;
        anyedge <= (in != delayed_in) ? 8'hFF : 8'h00;
    end

endmodule