module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg [2:0] neighbors = { (i > 0)? current_state[i-1] : 1'b0, 
                                current_state[i], 
                                (i < 511)? current_state[i+1] : 1'b0 };
        case (neighbors)
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
end

assign q = current_state;

endmodule