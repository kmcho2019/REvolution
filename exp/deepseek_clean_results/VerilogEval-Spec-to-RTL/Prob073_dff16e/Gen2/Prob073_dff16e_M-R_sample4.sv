module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

reg [15:0] q_reg;

// Upper byte (bits 15:8)
wire [7:0] upper_byte = (!resetn) ? 8'b0 : 
                        (byteena[1]) ? d[15:8] : q_reg[15:8];

// Lower byte (bits 7:0)
wire [7:0] lower_byte = (!resetn) ? 8'b0 : 
                        (byteena[0]) ? d[7:0] : q_reg[7:0];

// Update registers on clock edge
always @(posedge clk) begin
    q_reg <= {upper_byte, lower_byte};
end

assign q = q_reg;

endmodule