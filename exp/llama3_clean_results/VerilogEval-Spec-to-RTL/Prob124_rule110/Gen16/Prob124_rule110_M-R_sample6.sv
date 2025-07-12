module NextState(
    input left,
    input center,
    input right,
    output next_state
);

    always @(*) begin
        case ({left, center, right})
            3'b111: next_state = 1'b0;
            3'b110, 3'b101, 3'b011, 3'b010, 3'b001: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] shift_register;

generate
    for (genvar i = 0; i < 512; i++) begin
        wire left, center, right, next_state;
        NextState ns(left, center, right, next_state);

        assign left = (i == 0)? 1'b0 : shift_register[i - 1];
        assign center = shift_register[i];
        assign right = (i == 511)? 1'b0 : shift_register[i + 1];

        always @(posedge clk) begin
            if (load) begin
                shift_register[i] <= data[i];
            end else begin
                shift_register[i] <= next_state;
            end
        end
    end
endgenerate

assign q = shift_register;

endmodule