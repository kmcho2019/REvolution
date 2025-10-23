module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_count;

// Combinational logic to determine next count value
always @(*) begin
    if (!rst_n) begin
        next_count = 4'b0000;
    end else if (valid_count) begin
        if (out == 4'd11)
            next_count = 4'b0000;
        else
            next_count = out + 1'b1;
    end else begin
        next_count = out; // Hold current count
    end
end

// Sequential logic to update counter on clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_count;
    end
end

endmodule