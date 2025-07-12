module TopModule (
    input           clk,
    input           reset,
    input   [7:0]    d,
    output  [7:0]    q
);

reg [7:0] q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 8'h34;
    end else begin
        q_reg <= d;
    end
end

assign q = ~clk ? d : q_reg;

// Alternatively, if you really want to use negedge triggered DFFs
// always @(negedge clk or posedge reset) begin
//     if (reset) begin
//         q_reg <= 8'h34;
//     end else begin
//         q_reg <= d;
//     end
// end
// assign q = q_reg;

endmodule