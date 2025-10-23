module Cell(
    input clk,
    input load,
    input data,
    input left,
    input right,
    output reg q
);

reg state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        case ({left, state, right})
            3'b111: state <= 1'b0;
            3'b110: state <= 1'b1;
            3'b101: state <= 1'b1;
            3'b100: state <= 1'b0;
            3'b011: state <= 1'b1;
            3'b010: state <= 1'b1;
            3'b001: state <= 1'b1;
            default: state <= 1'b0;
        endcase
    end
end

assign q = state;

endmodule

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
            reg left, right, state;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = current_state[i - 1];
            end
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = current_state[i + 1];
            end
            state = current_state[i];
            case ({left, state, right})
                3'b111: current_state[i] <= 1'b0;
                3'b110: current_state[i] <= 1'b1;
                3'b101: current_state[i] <= 1'b1;
                3'b100: current_state[i] <= 1'b0;
                3'b011: current_state[i] <= 1'b1;
                3'b010: current_state[i] <= 1'b1;
                3'b001: current_state[i] <= 1'b1;
                default: current_state[i] <= 1'b0;
            endcase
        end
    end
end

assign q = current_state;

endmodule