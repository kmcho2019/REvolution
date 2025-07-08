module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] count; // 3 bits to count up to 4 (0 to 3)
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            if (count < 3'd3) begin
                count <= count + 1'b1;
                shift_ena <= 1'b1;
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

endmodule