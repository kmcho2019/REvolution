module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [255:0] q_low, q_high;
    wire [255:0] next_low, next_high;

    // Compute left and right neighbors for lower half with zero boundary
    wire [256:0] padded_low = {1'b0, q_low, 1'b0};
    assign next_low = padded_low[255:0] ^ padded_low[257:2];

    // Compute left and right neighbors for upper half with zero boundary
    wire [256:0] padded_high = {1'b0, q_high, 1'b0};
    assign next_high = padded_high[255:0] ^ padded_high[257:2];

    always @(posedge clk) begin
        if (load) begin
            q_low <= data[255:0];
            q_high <= data[511:256];
            q <= data;
        end else begin
            q_low <= next_low;
            q_high <= next_high;
            q <= {next_high, next_low};
        end
    end

endmodule