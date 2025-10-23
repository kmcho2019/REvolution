module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        // LFSR-style counter with custom feedback for binary counting
        count <= {count[2:0], ~count[3]};  // Basic shift with feedback
        
        // Corrective logic to maintain binary counting sequence
        if (count == 4'b0001) count <= 4'b0010;
        else if (count == 4'b0011) count <= 4'b0100;
        else if (count == 4'b0111) count <= 4'b1000;
        else if (count == 4'b1111) count <= 4'b0000;
    end
end

assign q = count;

endmodule