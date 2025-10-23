module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

integer i;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (i = 0; i < 512; i++) begin
            // Handle boundaries
            wire left, center, right;
            if (i == 0) begin
                left = 1'b0;
                center = q[i];
                right = q[i+1];
            end else if (i == 511) begin
                left = q[i-1];
                center = q[i];
                right = 1'b0;
            end else begin
                left = q[i-1];
                center = q[i];
                right = q[i+1];
            end

            // Compute next state
            if (left && center && right) begin
                q[i] <= 1'b0;
            end else if (left && center && ~right) begin
                q[i] <= 1'b1;
            end else if (left && ~center && right) begin
                q[i] <= 1'b1;
            end else if (left && ~center && ~right) begin
                q[i] <= 1'b0;
            end else if (~left && center && right) begin
                q[i] <= 1'b1;
            end else if (~left && center && ~right) begin
                q[i] <= 1'b1;
            end else if (~left && ~center && right) begin
                q[i] <= 1'b1;
            end else begin
                q[i] <= 1'b0;
            end
        end
    end
end

endmodule