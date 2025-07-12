module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    // Byte enables for clock gating logic
    wire lower_en = byteena[0];
    wire upper_en = byteena[1];

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update lower byte if enabled
            if (lower_en)
                q[7:0] <= d[7:0];
            // Update upper byte if enabled
            if (upper_en)
                q[15:8] <= d[15:8];
        end
    end

endmodule