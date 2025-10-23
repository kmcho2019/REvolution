module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    reg [15:0] data_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            data_reg <= 16'b0;
        end else begin
            // Upper byte update
            if (byteena[1]) begin
                data_reg[15:8] <= d[15:8];
            end
            
            // Lower byte update
            if (byteena[0]) begin
                data_reg[7:0] <= d[7:0];
            end
        end
    end

    assign q = data_reg;

endmodule