module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] prev_prev_in;
    
    always @(posedge clk) begin
        prev_prev_in <= prev_in;
        prev_in <= in;
    end
    
    always @(*) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            // Detect edge only if value was stable for at least 1 cycle before changing
            anyedge[i] = (prev_in[i] != prev_prev_in[i]) && 
                         (in[i] == prev_in[i]);
        end
    end

endmodule