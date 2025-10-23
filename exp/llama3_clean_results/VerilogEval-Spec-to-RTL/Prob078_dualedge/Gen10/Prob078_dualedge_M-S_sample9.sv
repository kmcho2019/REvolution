module TopModule(
    input clk,
    input d,
    output reg q
);

// Positive-edge triggered flip-flop
reg q_pos;

// Negative-edge triggered flip-flop
reg q_neg;

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Select output based on clock edge directly
always @(*) begin
    if(clk) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule