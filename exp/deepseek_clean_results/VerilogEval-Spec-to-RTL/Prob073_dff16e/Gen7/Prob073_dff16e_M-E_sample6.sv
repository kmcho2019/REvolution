module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Generate gated clocks for each byte
    wire upper_byte_clk;
    wire lower_byte_clk;
    
    assign upper_byte_clk = clk & byteena[1];
    assign lower_byte_clk = clk & byteena[0];

    // Upper byte (bits 15:8) register
    always @(posedge upper_byte_clk or negedge resetn) begin
        if (!resetn) begin
            q[15:8] <= 8'b0;
        end else begin
            q[15:8] <= d[15:8];
        end
    end

    // Lower byte (bits 7:0) register
    always @(posedge lower_byte_clk or negedge resetn) begin
        if (!resetn) begin
            q[7:0] <= 8'b0;
        end else begin
            q[7:0] <= d[7:0];
        end
    end

endmodule