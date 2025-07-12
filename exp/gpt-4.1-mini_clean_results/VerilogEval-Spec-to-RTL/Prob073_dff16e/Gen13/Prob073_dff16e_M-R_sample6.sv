module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    // Generate mask from byte enables
    wire [15:0] mask = { 
        {8{byteena[1]}},   // replicate byteena[1] 8 times for upper byte mask
        {8{byteena[0]}}    // replicate byteena[0] 8 times for lower byte mask
    };

    // Compute next state combinationally
    wire [15:0] next_q = (q & ~mask) | (d & mask);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Only update q if any byteena bit is set, else hold q
            q <= (byteena != 2'b00) ? next_q : q;
        end
    end

endmodule