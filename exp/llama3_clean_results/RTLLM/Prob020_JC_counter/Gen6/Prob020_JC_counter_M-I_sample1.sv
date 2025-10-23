module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Pipeline stage 1: Calculate the new most significant bit
reg [0:0] new_msb;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        new_msb <= 1'b0;
    end else begin
        new_msb <= ~Q[0];
    end
end

// Pipeline stage 2: Shift the counter value and append the new MSB
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= {new_msb, Q[63:1]};
    end
end

endmodule