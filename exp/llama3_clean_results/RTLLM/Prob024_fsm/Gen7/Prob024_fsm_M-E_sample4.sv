module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] sequence;
reg [4:0] shifted_sequence;

// Stage 1: Shift the input sequence
always_ff @(posedge CLK or posedge RST) begin
    if(RST) begin
        sequence = 5'b00000;
    end else begin
        sequence = {IN, sequence[4:1]};
    end
end

// Stage 2: Check the sequence
always_comb begin
    shifted_sequence = {sequence[4:1], 1'b0};
    MATCH = (sequence == 5'b10011);
end

// Output the result
always_ff @(posedge CLK or posedge RST) begin
    if(RST) begin
        MATCH = 1'b0;
    end else begin
        MATCH = MATCH;
    end
end

endmodule