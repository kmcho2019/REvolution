module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Virtual extended q with boundary conditions
    wire [513:0] q_ext = {1'b0, q, 1'b0};
    wire [511:0] q_next;

    // Compute next state for all cells
    assign q_next = q_ext[512:1] ^ q_ext[510:0];

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule