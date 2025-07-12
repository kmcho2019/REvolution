module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] circular_reg;
    wire enable_shift = (in != circular_reg[3]);  // Only shift when input changes
    
    always @(posedge clk) begin
        if (!resetn) begin
            circular_reg <= 4'b0;
        end
        else if (enable_shift) begin
            circular_reg <= {circular_reg[2:0], in};
        end
    end

    assign out = circular_reg[3];

endmodule