module TopModule #(
    parameter SIZE = 512
)(
    input clk,
    input load,
    input [SIZE-1:0] data,
    output [SIZE-1:0] q
);

reg [SIZE-1:0] state;

// Combinational logic to compute the next state
always @(*) begin
    reg [SIZE-1:0] next_state;
    for (int i = 0; i < SIZE; i++) begin
        reg left, center, right;
        
        // Determine the states of the neighbors
        left = (i == 0) ? 1'b0 : state[i - 1];
        center = state[i];
        right = (i == SIZE - 1) ? 1'b0 : state[i + 1];
        
        // Use a case statement to implement the Rule 110 LUT
        case ({left, center, right})
            3'b111: next_state[i] = 1'b0;
            3'b110: next_state[i] = 1'b1;
            3'b101: next_state[i] = 1'b1;
            3'b100: next_state[i] = 1'b0;
            3'b011: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b001: next_state[i] = 1'b1;
            3'b000: next_state[i] = 1'b0;
        endcase
    end
    assign q = state;
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        state <= q;
    end
end

endmodule