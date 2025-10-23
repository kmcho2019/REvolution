module Cell(
    input clk,
    input load,
    input data,
    input left,
    input center,
    input right,
    output reg q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Rule 110 transition rules
        case ({left, center, right})
            3'b111, 3'b000, 3'b001, 3'b010: q <= 1'b0;
            default: q <= 1'b1;
        endcase
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = state[i - 1];
            end
            center = state[i];
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = state[i + 1];
            end
            // Rule 110 transition rules
            case ({left, center, right})
                3'b111, 3'b000, 3'b001, 3'b010: state[i] <= 1'b0;
                default: state[i] <= 1'b1;
            endcase
        end
    end
end

assign q = state;

endmodule