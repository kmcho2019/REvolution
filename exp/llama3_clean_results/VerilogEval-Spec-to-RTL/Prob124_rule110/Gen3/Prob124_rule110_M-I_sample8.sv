module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

integer i;

always @(*) begin
    for (i = 0; i < 512; i++) begin
        reg left, center, right;
        if (i == 0) begin
            left = 0;
            center = current_state[i];
            right = current_state[i + 1];
        end else if (i == 511) begin
            left = current_state[i - 1];
            center = current_state[i];
            right = 0;
        end else begin
            left = current_state[i - 1];
            center = current_state[i];
            right = current_state[i + 1];
        end
        
        reg [2:0] neighborhood = {left, center, right};
        case (neighborhood)
            3'b111, 3'b101, 3'b110, 3'b000: next_state[i] = 1'b0;
            3'b001, 3'b010, 3'b011, 3'b100: next_state[i] = 1'b1;
            default: next_state[i] = 1'bx; // undefined state
        endcase
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule