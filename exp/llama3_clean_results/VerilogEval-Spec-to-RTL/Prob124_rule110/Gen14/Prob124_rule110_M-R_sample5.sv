module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] shift_register;

always @(posedge clk) begin
    if (load) begin
        shift_register <= data;
    end else begin
        shift_register <= compute_next_state(shift_register);
    end
end

function [511:0] compute_next_state;
    input [511:0] current_state;
    reg [511:0] next_state;

    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        left = (i == 0)? 1'b0 : current_state[i - 1];
        center = current_state[i];
        right = (i == 511)? 1'b0 : current_state[i + 1];

        case ({left, center, right})
            3'b111: next_state[i] = 1'b0;
            3'b110, 3'b101, 3'b011, 3'b010, 3'b001: next_state[i] = 1'b1;
            default: next_state[i] = 1'b0;
        endcase
    end

    compute_next_state = next_state;
endfunction

assign q = shift_register;

endmodule