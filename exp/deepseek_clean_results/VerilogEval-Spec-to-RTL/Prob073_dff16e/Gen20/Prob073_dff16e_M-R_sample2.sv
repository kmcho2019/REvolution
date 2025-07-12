module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    reg [15:0] q_reg;

    // Next state logic with byte enables
    wire [15:0] next_q = 
        !resetn ? 16'h0000 :               // Synchronous reset
        {
            byteena[1] ? d[15:8] : q_reg[15:8],  // Upper byte enable
            byteena[0] ? d[7:0] : q_reg[7:0]     // Lower byte enable
        };

    // Sequential element
    always @(posedge clk) begin
        q_reg <= next_q;
    end

    // Output assignment
    assign q = q_reg;
endmodule