module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
assign q = current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 0;
            end else begin
                left = current_state[i-1];
            end
            center = current_state[i];
            if (i == 511) begin
                right = 0;
            end else begin
                right = current_state[i+1];
            end
            
            case ({left, center, right})
                3'b111: current_state[i] <= 0;
                3'b110: current_state[i] <= 1;
                3'b101: current_state[i] <= 1;
                3'b100: current_state[i] <= 0;
                3'b011: current_state[i] <= 1;
                3'b010: current_state[i] <= 1;
                3'b001: current_state[i] <= 1;
                3'b000: current_state[i] <= 0;
                default: current_state[i] <= 0;
            endcase
        end
    end
end

endmodule