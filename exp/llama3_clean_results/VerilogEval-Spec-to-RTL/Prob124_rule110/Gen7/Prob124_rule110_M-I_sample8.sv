module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
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
            
            case ({left, center, right})
                3'b111, 3'b000, 3'b001, 3'b100: current_state[i] <= 0;
                3'b101, 3'b110, 3'b011, 3'b010: current_state[i] <= 1;
            endcase
        end
    end
end

assign q = current_state;

endmodule