module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

    wire [7:0] upper_byte;
    wire [7:0] lower_byte;
    wire [15:0] next_q;

    // Upper byte selects d or q based on byteena[1]
    assign upper_byte = byteena[1] ? d[15:8] : q[15:8];

    // Lower byte selects d or q based on byteena[0]
    assign lower_byte = byteena[0] ? d[7:0] : q[7:0];

    // Combine upper and lower bytes
    assign next_q = {upper_byte, lower_byte};

    // Sequential update of q with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            q <= next_q;
    end

endmodule