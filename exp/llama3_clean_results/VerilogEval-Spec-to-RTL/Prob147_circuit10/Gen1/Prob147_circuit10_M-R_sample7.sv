module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

// Initial state
initial begin
    state = 1'b0;
end

// State machine
always @(posedge clk) begin
    if (a == 1'b0 && b == 1'b1) begin
        state <= 1'b1;
    end else if (a == 1'b1 && b == 1'b1) begin
        state <= 1'b0;
    end else begin
        state <= state;  // self-loop
    end

    if (a == 1'b1 && b == 1'b0) begin
        q <= 1'b1;
    end else if (state == 1'b1 && b == 1'b1) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
end

endmodule