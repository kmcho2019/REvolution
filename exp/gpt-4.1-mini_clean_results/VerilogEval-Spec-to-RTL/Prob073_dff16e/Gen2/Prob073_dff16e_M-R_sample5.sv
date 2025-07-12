module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

    reg [15:0] next_q;

    // Combinational logic to determine next_q based on byte enables and input d
    always @* begin
        next_q = q;  // default: hold current value
        if (byteena[1])
            next_q[15:8] = d[15:8];
        if (byteena[0])
            next_q[7:0] = d[7:0];
    end

    // Sequential update of q with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            q <= next_q;
    end

endmodule