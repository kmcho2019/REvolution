module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] q;

    always @ (posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end

    // Alternatively, you can use individual DFFs for each bit, but the above implementation is more concise and efficient.
    // Here's how you might do it with individual DFFs for clarity and educational purposes:

    // reg [7:0] q;

    // always @ (posedge clk or posedge areset) begin
    //     if (areset) begin
    //         q[0] <= 1'b0;
    //         q[1] <= 1'b0;
    //         q[2] <= 1'b0;
    //         q[3] <= 1'b0;
    //         q[4] <= 1'b0;
    //         q[5] <= 1'b0;
    //         q[6] <= 1'b0;
    //         q[7] <= 1'b0;
    //     end else begin
    //         q[0] <= d[0];
    //         q[1] <= d[1];
    //         q[2] <= d[2];
    //         q[3] <= d[3];
    //         q[4] <= d[4];
    //         q[5] <= d[5];
    //         q[6] <= d[6];
    //         q[7] <= d[7];
    //     end
    // end

endmodule