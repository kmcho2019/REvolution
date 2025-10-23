module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  [15:0]  q
);

    reg [7:0] q_lower;
    reg [7:0] q_upper;

    // Next state logic for lower byte
    wire [7:0] next_lower = (byteena[0]) ? d[7:0] : q_lower;
    // Next state logic for upper byte
    wire [7:0] next_upper = (byteena[1]) ? d[15:8] : q_upper;

    always @(posedge clk) begin
        if (!resetn) begin
            q_lower <= 8'b0;
        end else begin
            q_lower <= next_lower;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            q_upper <= 8'b0;
        end else begin
            q_upper <= next_upper;
        end
    end

    // Combine upper and lower bytes to form output
    assign q = {q_upper, q_lower};

endmodule