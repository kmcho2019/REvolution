module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in1, prev_in2;
    
    always @(posedge clk) begin
        // Edge detected when current input differs from both previous samples
        anyedge <= (in != prev_in1) & (in != prev_in2);
        
        // Update history registers
        prev_in2 <= prev_in1;
        prev_in1 <= in;
    end

endmodule