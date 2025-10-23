module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];

    // Compute next state combinationally
    wire [31:0] next_q;
    assign next_q = {
        q[31] ^ feedback,      // bit 31 tap
        q[30], 
        q[29],
        q[28],
        q[27],
        q[26],
        q[25],
        q[24],
        q[23],
        q[22],
        q[21] ^ feedback,      // bit 21 tap
        q[20],
        q[19],
        q[18],
        q[17],
        q[16],
        q[15],
        q[14],
        q[13],
        q[12],
        q[11],
        q[10],
        q[9],
        q[8],
        q[7],
        q[6],
        q[5],
        q[4],
        q[3],
        q[2],
        q[1] ^ feedback,       // bit 1 tap
        q[0] ^ feedback        // bit 0 tap
    };

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule