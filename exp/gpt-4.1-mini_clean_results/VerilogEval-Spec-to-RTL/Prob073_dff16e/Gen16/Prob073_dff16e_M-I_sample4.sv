module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

wire [7:0] upper_mask = {8{byteena[1]}};
wire [7:0] lower_mask = {8{byteena[0]}};
wire [15:0] write_mask = {upper_mask, lower_mask};

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else begin
        // Update upper byte if enabled
        if (byteena[1])
            q[15:8] <= d[15:8];
        // Otherwise, hold current value for upper byte
        else
            q[15:8] <= q[15:8];

        // Update lower byte if enabled
        if (byteena[0])
            q[7:0] <= d[7:0];
        else
            q[7:0] <= q[7:0];
    end
end

endmodule