module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Upper byte (bits 15:8)
    wire [7:0] upper_byte_in = byteena[1] ? d[15:8] : q[15:8];
    reg [7:0] upper_byte_reg;
    
    // Lower byte (bits 7:0)
    wire [7:0] lower_byte_in = byteena[0] ? d[7:0] : q[7:0];
    reg [7:0] lower_byte_reg;
    
    // Combine outputs
    assign q = {upper_byte_reg, lower_byte_reg};
    
    // Upper byte flip-flop
    always @(posedge clk) begin
        if (!resetn)
            upper_byte_reg <= 8'b0;
        else
            upper_byte_reg <= upper_byte_in;
    end
    
    // Lower byte flip-flop
    always @(posedge clk) begin
        if (!resetn)
            lower_byte_reg <= 8'b0;
        else
            lower_byte_reg <= lower_byte_in;
    end

endmodule