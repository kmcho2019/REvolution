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
        reg left, center, right;
        
        // Handle boundary conditions
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = current_state[i-1];
        end
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = current_state[i+1];
        end
        center = current_state[i];

        // Apply Rule 110 using conditional expressions
        reg temp;
        case ({left, center, right})
            3'b111: temp = 1'b0;
            3'b110: temp = 1'b1;
            3'b101: temp = 1'b1;
            3'b100: temp = 1'b0;
            3'b011: temp = 1'b1;
            3'b010: temp = 1'b1;
            3'b001: temp = 1'b1;
            3'b000: temp = 1'b0;
            default: temp = 1'b0;
        endcase
        next_state[i] = temp;
    end
end

assign q = current_state;

endmodule