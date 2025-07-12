module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Level 1: First bit match (1)
reg match_l1;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        match_l1 <= 1'b0;
    else
        match_l1 <= data_in;
end

// Level 2: Second bit match (0)
reg match_l2;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        match_l2 <= 1'b0;
    else
        match_l2 <= match_l1 & ~data_in;
end

// Level 3: Third bit match (0)
reg match_l3;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        match_l3 <= 1'b0;
    else
        match_l3 <= match_l2 & ~data_in;
end

// Level 4: Final bit match (1) and output
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        sequence_detected <= 1'b0;
    else
        sequence_detected <= match_l3 & data_in;
end

endmodule