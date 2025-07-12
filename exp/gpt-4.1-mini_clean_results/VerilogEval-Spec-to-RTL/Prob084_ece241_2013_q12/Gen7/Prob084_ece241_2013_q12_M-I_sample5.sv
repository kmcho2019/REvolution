module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output reg   Z
);

    reg [7:0] Q;

    // Shift register with vector concatenation; shift in S as LSB
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Registered output with direct vector indexing using ABC as index
    wire [2:0] addr = {A, B, C};
    always @(posedge clk) begin
        Z <= Q[addr];
    end

endmodule