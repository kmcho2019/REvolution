module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0; // Corresponds to q=1
        end else begin
            if (count == 4'd9) // Count 0 to 9 => q = count + 1 counts 1 to 10
                count <= 4'd0;
            else
                count <= count + 1'b1;
        end
    end

    // Output q is count + 1 to get 1 to 10 sequence
    always @(*) begin
        q = count + 1'b1;
    end

endmodule